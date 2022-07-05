package com.zj.lable.demo;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;


import zj.com.customize.sdk.Other;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.provider.MediaStore.MediaColumns;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.Toast;

public class Main_Activity extends Activity implements OnClickListener {
    /******************************************************************************************************/

    protected String[] needPermissions = {
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.CAMERA,
            Manifest.permission.RECORD_AUDIO

    };

    /**
     * 判断是否需要检测，防止不停的弹框
     */
    private boolean isNeedCheck = true;




    // Debugging
    private static final String TAG = "Main_Activity";
    private static final boolean DEBUG = true;
    private boolean isReceive = false;
    /******************************************************************************************************/
    // Message types sent from the BluetoothService Handler
    public static final int MESSAGE_STATE_CHANGE = 1;
    public static final int MESSAGE_READ = 2;
    public static final int MESSAGE_WRITE = 3;
    public static final int MESSAGE_DEVICE_NAME = 4;
    public static final int MESSAGE_TOAST = 5;
    public static final int MESSAGE_CONNECTION_LOST = 6;
    public static final int MESSAGE_UNABLE_CONNECT = 7;
    public static final int MESSAGE_STOP_VIEW = 8;
    /*******************************************************************************************************/
    // Key names received from the BluetoothService Handler
    public static final String DEVICE_NAME = "device_name";
    public static final String TOAST = "toast";

    // Intent request codes
    private static final int REQUEST_CONNECT_DEVICE = 1;
    private static final int REQUEST_ENABLE_BT = 2;
    private static final int REQUEST_CHOSE_BMP = 3;
    private static final int REQUEST_CAMER = 4;


    private TextView mTitle;
    EditText editText;
    ImageView imageViewPicture;

    private Button sendButton = null;


    private Button btnScanButton = null;
    private Button btnClose = null;
    private Button btn_BMP = null;
    private EditText et_w = null;
    private EditText et_h = null;
    /******************************************************************************************************/
    // Name of the connected device
    private String mConnectedDeviceName = null;
    // Local Bluetooth adapter
    private BluetoothAdapter mBluetoothAdapter = null;
    // Member object for the services
    private BluetoothService mService = null;




    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (DEBUG)
            Log.e(TAG, "+++ ON CREATE +++");

        // Set up the window layout
        //requestWindowFeature(Window.FEATURE_CUSTOM_TITLE);
        //    requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.main);


        // Set up the custom title
        mTitle = (TextView) findViewById(R.id.title_left_text);
        mTitle.setText(R.string.app_title);
        mTitle = (TextView) findViewById(R.id.title_right_text);

        // Get local Bluetooth adapter
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        // If the adapter is null, then Bluetooth is not supported
        if (mBluetoothAdapter == null) {
            Toast.makeText(this, "Bluetooth is not available",
                    Toast.LENGTH_LONG).show();
            finish();
        }

    }



    @Override
    public void onStart() {
        super.onStart();

        // If Bluetooth is not on, request that it be enabled.
        // setupChat() will then be called during onActivityResult
        if (!mBluetoothAdapter.isEnabled()) {
            Intent enableIntent = new Intent(
                    BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(enableIntent, REQUEST_ENABLE_BT);
            // Otherwise, setup the session
        } else {
            if (mService == null)
                KeyListenerInit();//监听
        }
    }

    /**
     *
     * @param permissions
     * @since 2.5.0
     * requestPermissions方法是请求某一权限，
     */
    private void checkPermissions(String... permissions) {
        List<String> needRequestPermissonList = findDeniedPermissions(permissions);
        if (null != needRequestPermissonList && needRequestPermissonList.size() > 0) {
            ActivityCompat.requestPermissions(Main_Activity.this, needRequestPermissonList.toArray(
                    new String[needRequestPermissonList.size()]),
                    1);
        }
    }
    /**
     * 获取权限集中需要申请权限的列表
     *
     * @param permissions
     * @return
     * @since 2.5.0
     * checkSelfPermission方法是在用来判断是否app已经获取到某一个权限
     * shouldShowRequestPermissionRationale方法用来判断是否
     * 显示申请权限对话框，如果同意了或者不在询问则返回false
     */
    private List<String> findDeniedPermissions(String[] permissions) {
        List<String> needRequestPermissonList = new ArrayList<String>();
        for (String perm : permissions) {
            if (ContextCompat.checkSelfPermission(Main_Activity.this,perm) != PackageManager.PERMISSION_GRANTED) {
                needRequestPermissonList.add(perm);
            } else {
                if (ActivityCompat.shouldShowRequestPermissionRationale(Main_Activity.this, perm)) {
                    needRequestPermissonList.add(perm);
                }
            }
        }
        return needRequestPermissonList;
    }
    /**
     * 检测是否所有的权限都已经授权
     * @param grantResults
     * @return
     * @since 2.5.0
     *
     */
    private boolean verifyPermissions(int[] grantResults) {
        for (int result : grantResults) {
            if (result != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    @SuppressLint({ "Override", "NewApi" })
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] paramArrayOfInt) {
        if (requestCode == 1) {
            if (!verifyPermissions(paramArrayOfInt)) {
                //showMissingPermissionDialog();
                isNeedCheck = false;
            }

        }

    }
    @Override
    public synchronized void onResume() {
        super.onResume();
        if(isNeedCheck){
            checkPermissions(needPermissions);
        }
        if (mService != null) {

            if (mService.getState() == BluetoothService.STATE_NONE) {
                // Start the Bluetooth services
                mService.start();
            }
        }
    }

    @Override
    public synchronized void onPause() {
        super.onPause();
        if (DEBUG)
            Log.e(TAG, "- ON PAUSE -");
    }

    @Override
    public void onStop() {
        super.onStop();
        if (DEBUG)
            Log.e(TAG, "-- ON STOP --");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        // Stop the Bluetooth services
        if (mService != null)
            mService.stop();
        if (DEBUG)
            Log.e(TAG, "--- ON DESTROY ---");




    }

    /*****************************************************************************************************/
    private void KeyListenerInit() {

        editText = (EditText) findViewById(R.id.edit_text_out);

        sendButton = (Button) findViewById(R.id.Send_Button);
        sendButton.setOnClickListener(this);
        btnScanButton = (Button) findViewById(R.id.button_scan);
        btnScanButton.setOnClickListener(this);

        imageViewPicture = (ImageView) findViewById(R.id.imageViewPictureUSB);
        btnClose = (Button) findViewById(R.id.btn_close);
        btnClose.setOnClickListener(this);

        btn_BMP = (Button) findViewById(R.id.btn_prtbmp);
        btn_BMP.setOnClickListener(this);

        et_w = findViewById(R.id.et_w);
        et_h = findViewById(R.id.et_h);

        editText.setEnabled(false);
        imageViewPicture.setEnabled(false);

        sendButton.setEnabled(false);


        btnClose.setEnabled(false);
        btn_BMP.setEnabled(false);

        mService = new BluetoothService(this, mHandler);
    }

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
        switch (v.getId()) {
            case R.id.button_scan: {

                // If Bluetooth is not on, request that it be enabled.
                // setupChat() will then be called during onActivityResult
                if (!mBluetoothAdapter.isEnabled()) {
                    Intent enableIntent = new Intent(
                            BluetoothAdapter.ACTION_REQUEST_ENABLE);
                    startActivityForResult(enableIntent, REQUEST_ENABLE_BT);
                    // Otherwise, setup the session
                    return;
                } else {
                    if (mService == null)
                        KeyListenerInit();//监听
                }


                Intent serverIntent = new Intent(Main_Activity.this, DeviceListActivity.class);
                startActivityForResult(serverIntent, REQUEST_CONNECT_DEVICE);
                break;
            }
            case R.id.btn_close: {
                stop();
                break;
            }
//            case R.id.btn_test: {
//                BluetoothPrintTest();
//                ;
//                break;
//            }
            case R.id.Send_Button: {

                String text = editText.getText().toString();
                if(!TextUtils.isEmpty(text)){
                    int w = Integer.valueOf(et_w.getText().toString());
                    int h = Integer.valueOf(et_h.getText().toString());
                    LabelCommand tsc = new LabelCommand();
                    tsc.addSize(w, h);
                    tsc.addGap(2);
                    tsc.addCls();
                    tsc.addText(50, 50, LabelCommand.FONTTYPE.SIMPLIFIED_CHINESE, LabelCommand.ROTATION.ROTATION_0,
                            LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, text);
                    tsc.addPrint(1);
                    Vector<Byte> datas = tsc.getCommand(); // 发送数据
                    byte[] bytes = LabelUtils.ByteTo_byte(datas);
                    SendDataByte(bytes);
                }

                break;
            }

            case R.id.imageViewPictureUSB: {
                Intent loadPicture = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                startActivityForResult(loadPicture, REQUEST_CHOSE_BMP);
                break;
            }
            case R.id.btn_prtbmp: {
                int w = Integer.valueOf(et_w.getText().toString());
                int h = Integer.valueOf(et_h.getText().toString());
                Print_BMP(w,h);





//                LabelCommand tsc = new LabelCommand();
//                tsc.addSize(w, h);
//                tsc.addGap(2);
//                tsc.addCls();
//                tsc.addQRCode(50,50,LabelCommand.EEC.LEVEL_H,10,LabelCommand.ROTATION.ROTATION_0,"12345678");
//                tsc.addPrint(1);
//                Vector<Byte> datas = tsc.getCommand(); // 发送数据
//                byte[] bytes = LabelUtils.ByteTo_byte(datas);
//                SendDataByte(bytes);






                break;
            }



            default:
                break;
        }
    }



    private void stop() {
        mService.stop();
        editText.setEnabled(false);
        imageViewPicture.setEnabled(false);

        sendButton.setEnabled(false);


        btnClose.setEnabled(false);
        btn_BMP.setEnabled(false);



        btnScanButton.setEnabled(true);

        btnScanButton.setText(getText(R.string.connect));
    }

    /*****************************************************************************************************/
    /*
     * SendDataString
     */
    private void SendDataString(String data) {

        if (mService.getState() != BluetoothService.STATE_CONNECTED) {
            Toast.makeText(this, R.string.not_connected, Toast.LENGTH_SHORT)
                    .show();
            return;
        }
        if (data.length() > 0) {
            try {
                mService.write(data.getBytes("GBK"));
            } catch (UnsupportedEncodingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    private void SendDataStringEncode(String data,String encode) {

        if (mService.getState() != BluetoothService.STATE_CONNECTED) {
            Toast.makeText(this, R.string.not_connected, Toast.LENGTH_SHORT)
                    .show();
            return;
        }
        if (data.length() > 0) {
            try {
                mService.write(data.getBytes(encode));
                mService.write(data.getBytes(data));

            } catch (UnsupportedEncodingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    /*
     *SendDataByte
     */
    private void SendDataByte(byte[] data) {

        if (mService.getState() != BluetoothService.STATE_CONNECTED) {
            Toast.makeText(this, R.string.not_connected, Toast.LENGTH_SHORT)
                    .show();
            return;
        }
        mService.write(data);
    }

    /****************************************************************************************************/
    @SuppressLint("HandlerLeak")
    private final Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MESSAGE_STATE_CHANGE:
                    if (DEBUG)
                        Log.i(TAG, "MESSAGE_STATE_CHANGE: " + msg.arg1);
                    switch (msg.arg1) {
                        case BluetoothService.STATE_CONNECTED:
                            mTitle.setText(R.string.title_connected_to);
                            mTitle.append(mConnectedDeviceName);
                            btnScanButton.setText(getText(R.string.Connecting));

                            Toast.makeText(getApplicationContext(),
                                    R.string.Connecting, Toast.LENGTH_SHORT)
                                    .show();


                            btnScanButton.setEnabled(false);
                            editText.setEnabled(true);
                            imageViewPicture.setEnabled(true);

                            sendButton.setEnabled(true);


                            btnClose.setEnabled(true);
                            btn_BMP.setEnabled(true);





                            break;
                        case BluetoothService.STATE_CONNECTING:
                            mTitle.setText(R.string.title_connecting);
                            break;
                        case BluetoothService.STATE_LISTEN:
                        case BluetoothService.STATE_NONE:
                            mTitle.setText(R.string.title_not_connected);
                            break;
                    }
                    break;
                case MESSAGE_WRITE:

                    break;
                case MESSAGE_READ:


                    byte[] buff = (byte[])msg.obj;
                    for (int i=0;i<buff.length;i++){
                        //Log.e("read_msg",hex2Str(buff[i]+""));
                    }
                    try {
                        //Log.i("read_msg", new String(buff,"GBK"));
                        Log.i("read_msg", new String(buff));
                        String data = new String(buff);
                        if(data.contains("success")){
                            isReceive = true;
                            Toast.makeText(Main_Activity.this,"print success!!!",Toast.LENGTH_LONG).show();
                        }else if(data.contains("fail")){
                            Toast.makeText(Main_Activity.this,"print fail!!!",Toast.LENGTH_LONG).show();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }



                    break;
                case MESSAGE_DEVICE_NAME:
                    // save the connected device's name
                    mConnectedDeviceName = msg.getData().getString(DEVICE_NAME);
//                    Toast.makeText(getApplicationContext(),
//                            "Connected to " + mConnectedDeviceName,
//                            Toast.LENGTH_SHORT).show();
                    break;
                case MESSAGE_TOAST:
                    Toast.makeText(getApplicationContext(),
                            msg.getData().getString(TOAST), Toast.LENGTH_SHORT)
                            .show();
                    break;
                case MESSAGE_CONNECTION_LOST:    //蓝牙已断开连接
                    Toast.makeText(getApplicationContext(), "Device connection was lost",
                            Toast.LENGTH_SHORT).show();
                    editText.setEnabled(false);
                    imageViewPicture.setEnabled(false);

                    sendButton.setEnabled(false);


                    btnClose.setEnabled(false);
                    btn_BMP.setEnabled(false);


                    break;
                case MESSAGE_UNABLE_CONNECT:     //无法连接设备
                    Toast.makeText(getApplicationContext(), "Unable to connect device",
                            Toast.LENGTH_SHORT).show();
                    break;
                case MESSAGE_STOP_VIEW:     //无法连接设备
                    stop();
                    break;
            }
        }
    };

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (DEBUG)
            Log.d(TAG, "onActivityResult " + resultCode);
        switch (requestCode) {
            case REQUEST_CONNECT_DEVICE: {
                // When DeviceListActivity returns with a device to connect
                if (resultCode == Activity.RESULT_OK) {
                    // Get the device MAC address
                    //BluetoothDevice device = data.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                    String address = data.getExtras().getString(
                            DeviceListActivity.EXTRA_DEVICE_ADDRESS);
                    // Get the BLuetoothDevice object
                    if (BluetoothAdapter.checkBluetoothAddress(address)) {
                        BluetoothDevice device = mBluetoothAdapter
                                .getRemoteDevice(address);
                        // Attempt to connect to the device
                        mService.connect(device);
                        try {
                            //ClsUtils.createBond(device.getClass(), device);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
                break;
            }
            case REQUEST_ENABLE_BT: {
                // When the request to enable Bluetooth returns
                if (resultCode == Activity.RESULT_OK) {
                    // Bluetooth is now enabled, so set up a session
                    KeyListenerInit();
                } else {
                    // User did not enable Bluetooth or an error occured
                    Log.d(TAG, "BT not enabled");
                    Toast.makeText(this, R.string.bt_not_enabled_leaving,
                            Toast.LENGTH_SHORT).show();
                    finish();
                }
                break;
            }
            case REQUEST_CHOSE_BMP: {
                if (resultCode == Activity.RESULT_OK) {
                    Uri selectedImage = data.getData();
                    String[] filePathColumn = {MediaColumns.DATA};
                    Cursor cursor = getContentResolver().query(selectedImage,
                            filePathColumn, null, null, null);
                    cursor.moveToFirst();
                    int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
                    String picturePath = cursor.getString(columnIndex);
                    cursor.close();
                    BitmapFactory.Options opts = new BitmapFactory.Options();
                    opts.inJustDecodeBounds = true;
                    BitmapFactory.decodeFile(picturePath, opts);
                    opts.inJustDecodeBounds = false;
                    if (opts.outWidth > 1200) {
                        opts.inSampleSize = opts.outWidth / 1200;
                    }
                    Bitmap bitmap = BitmapFactory.decodeFile(picturePath, opts);
                    if (null != bitmap) {
                        imageViewPicture.setImageBitmap(bitmap);
                    }
                } else {
                    Toast.makeText(this, getString(R.string.msg_statev1), Toast.LENGTH_SHORT).show();
                }
                break;
            }
            case REQUEST_CAMER: {
                if (resultCode == Activity.RESULT_OK) {
                    handleSmallCameraPhoto(data);
                } else {
                    Toast.makeText(this, getText(R.string.camer), Toast.LENGTH_SHORT).show();
                }
                break;
            }
        }
    }

/****************************************************************************************************/




    /*
     * 打印图片
     */
    private void Print_BMP(int w,int h) {

        Bitmap mBitmap = loadBitmapFromView(imageViewPicture);

        if (mBitmap != null) {

            LabelCommand tsc = new LabelCommand();
            tsc.addSize(w, h);
            tsc.addGap(2);
            tsc.addCls();
            tsc.addBitmap(20,0,LabelCommand.BITMAP_MODE.OVERWRITE,150,mBitmap,"1");
            tsc.addPrint(1);
            Vector<Byte> datas = tsc.getCommand();
            byte[] bytes = LabelUtils.ByteTo_byte(datas);
            SendDataByte(bytes);


        }
    }

    /**
     * 把一个View转为Bitmap
     *
     * @param v
     * @return
     */
    public static Bitmap loadBitmapFromView(View v) {
        v.setDrawingCacheEnabled(true);
        v.setDrawingCacheQuality(View.DRAWING_CACHE_QUALITY_HIGH);
        v.setDrawingCacheBackgroundColor(Color.WHITE);

        int w = v.getWidth();
        int h = v.getHeight();

        Bitmap bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(bmp);

        c.drawColor(Color.WHITE);
        /** 如果不设置canvas画布为白色，则生成透明 */

        v.layout(v.getLeft(), v.getTop(), v.getRight(), v.getBottom());
        v.draw(c);

        return bmp;
    }

    /**
     * splitAry方法<br>
     * @param ary 要分割的数组
     * @param subSize 分割的块大小
     * @return
     *
     */
    public static Object[] splitAry(byte[] ary, int subSize) {
        int count = ary.length % subSize == 0 ? ary.length / subSize: ary.length / subSize + 1;

        List<List<Byte>> subAryList = new ArrayList<List<Byte>>();

        for (int i = 0; i < count; i++) {
            int index = i * subSize;
            List<Byte> list = new ArrayList<Byte>();
            int j = 0;
            while (j < subSize && index < ary.length) {
                list.add(ary[index++]);
                j++;
            }
            subAryList.add(list);
        }

        Object[] subAry = new Object[subAryList.size()];

        for(int i = 0; i < subAryList.size(); i++){
            List<Byte> subList = subAryList.get(i);
            byte[] subAryItem = new byte[subList.size()];
            for(int j = 0; j < subList.size(); j++){
                subAryItem[j] = subList.get(j);
            }
            subAry[i] = subAryItem;
        }

        return subAry;

    }

    //************************************************************************************************//
    /*
     * 调用系统相机
     */
    private void dispatchTakePictureIntent(int actionCode) {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        startActivityForResult(takePictureIntent, actionCode);
    }

    private void handleSmallCameraPhoto(Intent intent) {
        Bundle extras = intent.getExtras();
        Bitmap mImageBitmap = (Bitmap) extras.get("data");
        imageViewPicture.setImageBitmap(mImageBitmap);
    }
/****************************************************************************************************/
    /**
     * 加载assets文件资源
     */
    private Bitmap getImageFromAssetsFile(String fileName) {
        Bitmap image = null;
        AssetManager am = getResources().getAssets();
        try {
            InputStream is = am.open(fileName);
            image = BitmapFactory.decodeStream(is);
            is.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return image;

    }

}