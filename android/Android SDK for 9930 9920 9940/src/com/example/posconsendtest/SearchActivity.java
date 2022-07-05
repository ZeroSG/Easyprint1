package com.example.posconsendtest;

import java.util.ArrayList;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import net.posprinter.models.PrinterInfo;
import net.posprinter.utils.PrinterSearcher;

public class SearchActivity extends Activity implements OnClickListener {

	private Button btnSender, btnWeb;
	private TextView tvReceiver;

	private ReceiveHandler receiveHandler = new ReceiveHandler();
	
	private ArrayList<PrinterInfo> PrinterInfos = new ArrayList<PrinterInfo>();
	/*
	 * 处理接收到的数据
	 */
	class ReceiveHandler extends Handler {
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			PrinterInfo printerInfo = (PrinterInfo) msg.getData().getSerializable("PrinterInfo");
			Log.e("ReceiveHandler", printerInfo.getDeviceModel());
			PrinterInfos.add(printerInfo);
			tvReceiver.setText("IP:" + printerInfo.getDeviceIP() + ";mac: " + printerInfo.getDeviceMac() + ";Model:  "
					+ printerInfo.getDeviceModel() + ";Name:  " + printerInfo.getDeviceName() + ";Status:  "
					+ printerInfo.getDeviceStatus());
			btnWeb.setVisibility(View.VISIBLE);
		}
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_search);

		btnSender = (Button) findViewById(R.id.btn_search);
		btnSender.setOnClickListener(this);
		
		btnWeb = (Button) findViewById(R.id.btn_web);
		btnWeb.setOnClickListener(this);

		tvReceiver = (TextView) findViewById(R.id.tv_receiver);

		// 进入Activity时开启接收报文线程
		PrinterSearcher.startReceiver(SearchActivity.this, receiveHandler);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_search:
			tvReceiver.setText("no printer found");
			PrinterInfos.clear();
			btnWeb.setVisibility(View.GONE);
			PrinterSearcher.search();
			break;
		case R.id.btn_web:
			web(0);
			break;

		default:
			break;
		}

	}

	private void web(int i) {
		String address = PrinterInfos.get(i).getDeviceIP();
		Intent intent = new Intent();        
        intent.setAction("android.intent.action.VIEW");    
        Uri content_url = Uri.parse("http://" + address);   
        intent.setData(content_url);  
        startActivity(intent);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		// 停止接收线程，关闭套接字连接
		PrinterSearcher.closeReceiver();
	}

}
