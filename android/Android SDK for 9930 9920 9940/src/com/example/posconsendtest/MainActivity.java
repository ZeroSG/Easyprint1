package com.example.posconsendtest;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;


import net.posprinter.posprinterface.IMyBinder;
import net.posprinter.posprinterface.ProcessData;
import net.posprinter.posprinterface.UiExecute;
import net.posprinter.service.PosprinterService;
import net.posprinter.utils.BitmapToByteData.BmpType;
import net.posprinter.utils.DataForSendToPrinterTSC;
import net.posprinter.utils.PosPrinterDev;
import net.posprinter.utils.QueryStatus;
import net.posprinter.utils.ReadExcel;
import net.posprinter.utils.RoundQueue;
import android.app.Activity;
import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;


public class MainActivity extends Activity {
	
	public static IMyBinder binder;//IMyBinder接口，所有可供调用的连接和发送数据的方法都封装在这个接口内
	//bindService的参数conn
	ServiceConnection conn=new ServiceConnection() {
		
		@Override
		public void onServiceDisconnected(ComponentName name) {

		}

		@Override
		public void onServiceConnected(ComponentName name, IBinder service) {
			//绑定成功
			binder=(IMyBinder) service;
			
			
			
		}
	};
	public static boolean isConnect = false;//用来标识连接状态的一个boolean值
	Button btnCon,btnDiscon,btnAll,btnText,btnBarcode,btnRead,btnImage,btn_scan,btnDevice,bt8,btn9,btnExcel,btnCheck,btnReadModel,btnSearch,btnpdfModel;
	RelativeLayout main;
	Spinner spinner;
	EditText et;
	int pos;
	private View dialogView,dialogView2,dialogView3;
	BluetoothAdapter blueadapter;
	private ArrayAdapter<String> adapter1,adapter2,adapter3;
	private ListView lv1,lv2,lv_usb;
	private LinearLayout ll1;
	private ArrayList<String> deviceList_bonded=new ArrayList<String>();
	private ArrayList<String> deviceList_found=new ArrayList<String>();
	AlertDialog dialog;
	public  String mac="",usbDev="";
	TextView tv_usb;
	private List<String> usbList,usblist;
	PosPrinterDev posdev;
	private DeviceReceiver myDevice=new DeviceReceiver();
//	private Bitmap bitmap;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		//绑定service，获取ImyBinder对象
		Intent intent=new Intent(this,PosprinterService.class);
		bindService(intent, conn, BIND_AUTO_CREATE);
		// 注册蓝牙广播接收者
		IntentFilter filterStart = new IntentFilter(BluetoothDevice.ACTION_FOUND);
		IntentFilter filterEnd = new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
		registerReceiver(myDevice, filterStart);
		registerReceiver(myDevice, filterEnd);
		//初始化控件
		btnCon=(Button) findViewById(R.id.btn_con);
		btnDiscon=(Button) findViewById(R.id.btn_discon);
		btnAll=(Button) findViewById(R.id.btn_all);
		btnText=(Button) findViewById(R.id.btn_text);
		btnBarcode=(Button) findViewById(R.id.btn_barcode);
		btnRead=(Button) findViewById(R.id.btn_read);
		btnImage=(Button) findViewById(R.id.btn_image);
		btnDevice=(Button) findViewById(R.id.btn_device);
		spinner=(Spinner) findViewById(R.id.spinner1);
		et=(EditText) findViewById(R.id.editText1);
		et.setText("192.168.1.138");
		bt8=(Button) findViewById(R.id.button8);
		btn9=(Button) findViewById(R.id.button9);
		btnExcel=(Button) findViewById(R.id.btn_excel);
		btnCheck=(Button) findViewById(R.id.btn_check);
		btnReadModel=(Button) findViewById(R.id.btn_read_model);
		btnpdfModel=(Button) findViewById(R.id.btn_pdf);
		btnSearch=(Button) findViewById(R.id.btn_search_printer);
		
		main = (RelativeLayout) findViewById(R.id.main);
		
		//给控件添加监听事件
		addListener();
		
		thread = new HandlerThread("receiver");
		thread.start();
		receiverHandler = new Handler(thread.getLooper());
		toastHandler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				super.handleMessage(msg);
				String s1 = (String) msg.getData().get("key");
					Toast.makeText(MainActivity.this, s1, Toast.LENGTH_SHORT).show();

			}
		};
		statusHandler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				super.handleMessage(msg);
				String s1 = (String) msg.getData().get("status");
				btnText.setText(s1);

			}
		};
	}
	private void addListener() {
		btn9.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				startActivity(new Intent(MainActivity.this,P76Activity.class));
			}
		});
		bt8.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				startActivity(new Intent(MainActivity.this, PosActivity.class));
			}
		});
		btnDevice.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				switch (pos) {
				case 1:
					connectBLE();
					break;
				case 2:
					setUsb();
					break;
				default:
					break;
				}
			}
		});
		spinner.setOnItemSelectedListener(new OnItemSelectedListener() {

			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				pos=arg2;
				switch (arg2) {
				case 0:
					et.setText("");
					et.setHint(getString(R.string.hint));
					et.setEnabled(true);
					btnDevice.setVisibility(View.GONE);
					break;
				case 1:
					et.setText("");
					et.setHint(getString(R.string.bleselect));
					et.setEnabled(false);
					btnDevice.setVisibility(View.VISIBLE);
					//connectBLE();
					break;
				case 2:
					et.setText("");
					et.setHint(getString(R.string.usbselect));
					et.setEnabled(false);
					btnDevice.setVisibility(View.VISIBLE);
					//setUsb();
					break;
				default:
					break;
				}
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0) {
				
			}
		});
		//新增的打印图片示例代码
		btnImage.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent intent;
                intent = new Intent(Intent.ACTION_GET_CONTENT); 
                intent.addCategory(Intent.CATEGORY_OPENABLE);
                intent.setType("image/*");
                startActivityForResult(intent, 0);
			}
		});
		//新增的打印图片示例代码
		btnpdfModel.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						Intent intent;
		                intent = new Intent(Intent.ACTION_GET_CONTENT); 
		                intent.addCategory(Intent.CATEGORY_OPENABLE);
		                intent.setType("application/pdf");
		                startActivityForResult(intent, 1);
					}
				});
		//点击连接按钮，连接打印机
		btnCon.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				switch (pos) {
				case 0:
					connetNet();
					break;

				case 1:
					//connectBLE();
					sendble();
					break;
				case 2:
					connectUSB();
					break;
				default:
					break;
				}
				
			}
		});
		//断开按钮的监听事件
		btnDiscon.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if (isConnect) {//如果是连接状态才执行断开操作
					binder.disconnectCurrentPort(new UiExecute() {
						
						@Override
						public void onsucess() {
							Toast.makeText(getApplicationContext(), getString(R.string.toast_discon_success), 0).show();
						}
						
						@Override
						public void onfailed() {
							Toast.makeText(getApplicationContext(), getString(R.string.toast_discon_faile),0).show();
						}
					});
				}else{
					Toast.makeText(getApplicationContext(), getString(R.string.toast_present_con), 0).show();
				}
			}
		});
		//打印文本,直线，条码,二维码内容按钮btn2监听事件
		btnAll.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if (isConnect) {
					//向打印机发生打印指令和打印数据，调用此方法
					//第一个参数，还是UiExecute接口的实现，分别是发生数据成功和失败后在ui线程的处理
					binder.writeDataByYouself(new UiExecute() {

						@Override
						public void onsucess() {
							Toast.makeText(getApplicationContext(), getString(R.string.send_success), 0)
									.show();
						}

						@Override
						public void onfailed() {
							Toast.makeText(getApplicationContext(), getString(R.string.send_failed), 0)
									.show();
						}
					}, new ProcessData() {//第二个参数是ProcessData接口的实现
								//这个接口的重写processDataBeforeSend这个处理你要发送的指令

								@Override
								public List<byte[]> processDataBeforeSend() {
									//初始化一个list
									ArrayList<byte[]> list = new ArrayList<byte[]>();
									//在打印请可以先设置打印内容的字符编码类型，默认为gbk，请选择打印机可识别的类型，参看编程手册，打印代码页
									DataForSendToPrinterTSC.setCharsetName("gbk");//不设置，默认为gbk
									//通过工具类得到一个指令的byte[]数据,以文本为例
									//首先得设置size标签尺寸,宽60mm,高30mm,也可以调用以dot或inch为单位的方法具体换算参考编程手册
									byte[] data0 = DataForSendToPrinterTSC
											.sizeBymm(80, 40);
									list.add(data0);
									//设置Gap,同上
									list.add(DataForSendToPrinterTSC.gapBymm(2, 0));
									//list.add(DataForSendToPrinterTSC.blineBymm(2, 0));
									
									//清除缓存
									list.add(DataForSendToPrinterTSC.cls());
									//条码指令，参数：int x，x方向打印起始点；int y，y方向打印起始点；
									//string font，字体类型；int rotation，旋转角度；
									//int x_multiplication，字体x方向放大倍数
									//int y_multiplication,y方向放大倍数
									//string content，打印内容
									byte[] data1 = DataForSendToPrinterTSC
											.text(10, 10, "4", 0, 1, 1,
													"123abc");
									list.add(data1);
//									//打印直线,int x;int y;int width,线的宽度，int height,线的高度
									list.add(DataForSendToPrinterTSC.bar(20,
											40, 200, 3));
//									//打印条码
									list.add(DataForSendToPrinterTSC.barCode(
											60, 50, "128", 100, 1, 0, 2, 2,
											"abcdef12345"));
									//打印二维码
									list.add(DataForSendToPrinterTSC.qrCode(20, 180, "L", 4, "A", 0, "M2", "S7", "abcdef"));
									//打印
									list.add(DataForSendToPrinterTSC.print(1));
									return list;
								}
							});
				}else {
					Toast.makeText(getApplicationContext(), getString(R.string.not_con_printer), 0).show();
				}
			}
		});
		//单独打印文本
		btnText.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				//此处用binder里的另外一个发生数据的方法,同样，也要按照编程手册上的示例一样，先设置标签大小
				//如果数据处理较为复杂，请勿选择此方法
				//上面的发送方法的数据处理是在工作线程中完成的，不会阻塞UI线程
				byte[] data0=DataForSendToPrinterTSC.sizeBydot(812, 508);
				byte[] data4=DataForSendToPrinterTSC.gapBydot(16, 0);
				byte[] data1=DataForSendToPrinterTSC.cls();
			
				byte[] data2=DataForSendToPrinterTSC.text(10, 10, "5", 0, 2, 2, "12345678");
				byte[] data3=DataForSendToPrinterTSC.print(1);
				byte[] data=byteMerger(byteMerger(byteMerger(byteMerger(data0, data4), data1), data2),data3);
				if (isConnect) {
					binder.write(data, new UiExecute() {

						@Override
						public void onsucess() {
							Toast.makeText(getApplicationContext(), getString(R.string.send_success), 0)
									.show();
							//开启查询循环
							QueryStatus.startQuery(binder);
							//开启查询循环,时间
//							QueryStatus.startQuery(binder, 2000);
							//单次查询
//							binder.write(DataForSendToPrinterTSC.query(), new UiExecute() {
//								@Override
//								public void onsucess() {
//								}
//								@Override
//								public void onfailed() {
//								}
//							});
							
						}

						@Override
						public void onfailed() {
							Toast.makeText(getApplicationContext(), getString(R.string.send_failed), 0)
									.show();
						}
					});
				}else {
					Toast.makeText(getApplicationContext(), getString(R.string.not_con_printer), 0).show();
				}
			}
		});
		//打印条码
		btnBarcode.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if (isConnect) {
					binder.writeDataByYouself(new UiExecute() {

						@Override
						public void onsucess() {

						}

						@Override
						public void onfailed() {

						}
					}, new ProcessData() {

						@Override
						public List<byte[]> processDataBeforeSend() {
							//初始化一个list
							ArrayList<byte[]> list = new ArrayList<byte[]>();
							//通过工具类得到一个指令的byte[]数据,以文本为例
							//首先得设置size标签尺寸,宽60mm,高30mm,也可以调用以dot或inch为单位的方法具体换算参考编程手册
							byte[] data0 = DataForSendToPrinterTSC.sizeBymm(80,
									40);
							list.add(data0);
							//设置Gap,同上
							list.add(DataForSendToPrinterTSC.gapBymm(2, 0));
							//清除缓存
							list.add(DataForSendToPrinterTSC.cls());

							//打印条码
							list.add(DataForSendToPrinterTSC.barCode(60, 50,
									"128", 100, 1, 0, 2, 2, "abcdef12345"));
							//打印二维码
//							list.add(DataForSendToPrinterTSC.qrCode(200,100,"L", 4, "M", 0, "M2", "S7", "abcdef12345"));
							
							//打印
							list.add(DataForSendToPrinterTSC.print(1));
							return list;
						}
					});
				}else {
					Toast.makeText(getApplicationContext(), getString(R.string.not_con_printer), 0).show();
				}
			}
		});
		//读取打印机发送到缓存的环形队列里的数据，前提是，你已经开启了读取打印机数据的方法，btn0里的
		//binder.acceptdatafromprinter方法
		btnRead.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				RoundQueue<byte[]> que=binder.readBuffer();
				byte[] data=que.getLast();
				Log.i("TAG", "data="+data);
				if (data!=null) {
					
					btnRead.setText(Arrays.toString(data));
				}else {
					btnRead.setText("null");
				}
			}
		});
		
		//读取Excel数据
		btnExcel.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				//输入值为xls文件路径，和sheet号
				String key = "编号";
				int SheetNum = 0;
				int num = 9;
				HashMap<String, String[]> map = null;
				String[] sheet = null;
				try {
					map = ReadExcel.readExcel(MainActivity.this, "/sdcard/TBXprinter/file/test2.xls", SheetNum);
					sheet = ReadExcel.getExcelSheetName(MainActivity.this, "/sdcard/TBXprinter/file/test2.xls");
					String[] tmp = map.keySet().toArray(new String[0]);
					Log.e("hash test", "tmp.length = " + tmp.length);
					Log.e("hash test", " " + tmp[0] + "  " + tmp[1] + "  " + tmp[2] + "  " + tmp[3]);
					String str = map.get(key)[num - 1];
					Toast.makeText(MainActivity.this, key + "中的第" + num + "个数据为：" + str, Toast.LENGTH_SHORT).show();
					Log.e("excel sheet name", " " + sheet.length + "   第一个sheet为： " + sheet[0]);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
		
		//检纸
		btnCheck.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				try {
					binder.write(DataForSendToPrinterTSC.checkGap(), new UiExecute() {
						@Override
						public void onsucess() {
						}

						@Override
						public void onfailed() {
						}
					});
				} catch (Exception e) {
					Log.e("error", e.getMessage());
				}
			}
		});
		
		btnReadModel.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				getPrintModel();
				
			}
		});
		
		btnSearch.setOnClickListener(new OnClickListener() {			
			@Override
			public void onClick(View v) {
				startActivity(new Intent(MainActivity.this, SearchActivity.class));
			}
		});
	}
	protected void setUsb() {
		LayoutInflater inflater=LayoutInflater.from(this);
		dialogView3=inflater.inflate(R.layout.usb_link, null);
		tv_usb=(TextView) dialogView3.findViewById(R.id.textView1);
		lv_usb=(ListView) dialogView3.findViewById(R.id.listView1);
		
		
		
		usbList=PosPrinterDev.GetUsbPathNames(this);
		usblist=usbList;
		if (usbList==null) {
			usbList=new ArrayList<String>();	
		}
		tv_usb.setText(getString(R.string.usb_pre_con)+usbList.size());
		adapter3=new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, usbList);
		lv_usb.setAdapter(adapter3);
		
		AlertDialog dialog=new AlertDialog.Builder(this)
		.setView(dialogView3)
		.create();
		dialog.show();
		set_lv_usb_listener(dialog);
		
	}
	private void set_lv_usb_listener(final AlertDialog dialog) {
		lv_usb.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				usbDev=usbList.get(arg2);
				et.setText(usbDev);
				/*new Thread(){
					public void run() {
						posdev=null;
						try {
							posdev=new PosPrinterDev(net.posprinter.utils.PosPrinterDev.PortType.USB, getApplicationContext(), usbDev);
							posdev.Open();
							
						} catch (Exception e) {
							e.printStackTrace();
						}
					};
				}.start();*/
				binder.connectUsbPort(getApplicationContext(), usbDev, new UiExecute() {
					
					@Override
					public void onsucess() {
						
					}
					
					@Override
					public void onfailed() {
						
					}
				});
				dialog.cancel();
				Log.i("TAG", usbDev);
			}
		});
	}
	protected void connectUSB() {
		binder.connectUsbPort(getApplicationContext(), et.getText().toString(), new UiExecute() {
			
			@Override
			public void onsucess() {
				//连接成功后在UI线程中的执行
				isConnect=true;
				Toast.makeText(getApplicationContext(), getString(R.string.con_success), 0).show();
				btnCon.setText(getString(R.string.con_success)+PosPrinterDev.GetSerialNumber(getApplicationContext()).toString()+PosPrinterDev.GetUsbInfoList(getApplicationContext()).get(0).getProductId());
				//此处也可以开启读取打印机的数据
				//参数同样是一个实现的UiExecute接口对象
				//如果读的过程重出现异常，可以判断连接也发生异常，已经断开
				//这个读取的方法中，会一直在一条子线程中执行读取打印机发生的数据，
				//直到连接断开或异常才结束，并执行onfailed
				/*binder.acceptdatafromprinter(new UiExecute() {
					
					@Override
					public void onsucess() {
						
					}
					
					@Override
					public void onfailed() {
						isConnect=false;
						Toast.makeText(getApplicationContext(), getString(R.string.con_has_discon), 0).show();
					}
				});*/
				/*addReceiver();
				receiverHandler.post(run);*/
				
				
			}
			
			@Override
			public void onfailed() {
				//连接失败后在UI线程中的执行
				isConnect=false;
				Toast.makeText(getApplicationContext(), getString(R.string.con_failed), 0).show();
				btnCon.setText(getString(R.string.con_failed));
			}
		});
	}
	protected void connectBLE() {
		setbluetooth();
		//sendble();
	}
	public void sendble() {
		binder.connectBtPort(et.getText().toString(), new UiExecute() {
			
			@Override
			public void onsucess() {
				//连接成功后在UI线程中的执行
				isConnect=true;
				Toast.makeText(getApplicationContext(),getString(R.string.con_success), 0).show();
				btnCon.setText(getString(R.string.con_success));
				//此处也可以开启读取打印机的数据
				//参数同样是一个实现的UiExecute接口对象
				//如果读的过程重出现异常，可以判断连接也发生异常，已经断开
				//这个读取的方法中，会一直在一条子线程中执行读取打印机发生的数据，
				//直到连接断开或异常才结束，并执行onfailed
//				binder.acceptDataFromPrinter(new UiExecute() {
//					
//					@Override
//					public void onsucess() {
//						
//					}
//					
//					@Override
//					public void onfailed() {
//						isConnect=false;
//						Toast.makeText(getApplicationContext(), getString(R.string.con_has_discon), 0).show();
//					}
//				});
				addReceiver();
				receiverHandler.post(run);
			}
			
			@Override
			public void onfailed() {
				//连接失败后在UI线程中的执行
				isConnect=false;
				Toast.makeText(getApplicationContext(), getString(R.string.con_failed), 0).show();
				//btn0.setText("连接失败");
			}
		});
	}
	protected void setbluetooth() {
		blueadapter=BluetoothAdapter.getDefaultAdapter();
		//确认开启蓝牙  
		if(!blueadapter.isEnabled()){  
			//请求用户开启  
			Intent intent=new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);  
			startActivityForResult(intent, Conts.ENABLE_BLUETOOTH);  

		} else {
			//蓝牙已开启
			showblueboothlist();  
		} 

	}
	
	private void showblueboothlist() {
		if (!blueadapter.isDiscovering()) {
			blueadapter.startDiscovery();
		}
		LayoutInflater inflater=LayoutInflater.from(this);
		dialogView=inflater.inflate(R.layout.printer_list, null);
		adapter1=new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, deviceList_bonded);
		lv1=(ListView) dialogView.findViewById(R.id.listView1);
		btn_scan=(Button) dialogView.findViewById(R.id.btn_scan);
		ll1=(LinearLayout) dialogView.findViewById(R.id.ll1);
		lv2=(ListView) dialogView.findViewById(R.id.listView2);
		adapter2=new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, deviceList_found);
		lv1.setAdapter(adapter1);
		lv2.setAdapter(adapter2);
		dialog=new AlertDialog.Builder(this).setTitle("BLE").setView(dialogView).create();
		dialog.show();
		setlistener();
		findAvalibleDevice();
	}
	
	protected void connetNet() {
		//示例：连接打印机网口，参数为：（string）ip地址，（int）端口号，和一个实现的UiExecute接口对象
		//这个接口的实现在连接过程结束后执行（执行于UI线程），onsucess里执行连接成功的代码，onfailed反之；
		binder.connectNetPort(et.getText().toString(), 9100, new UiExecute() {
			
			@Override
			public void onsucess() {
				//连接成功后在UI线程中的执行
				isConnect=true;
				Toast.makeText(getApplicationContext(), getString(R.string.con_success), 0).show();
				btnCon.setText(getString(R.string.con_success));
				//此处也可以开启读取打印机的数据
				//参数同样是一个实现的UiExecute接口对象
				//如果读的过程重出现异常，可以判断连接也发生异常，已经断开
				//这个读取的方法中，会一直在一条子线程中执行读取打印机发生的数据，
				//直到连接断开或异常才结束，并执行onfailed
				binder.acceptDataFromPrinter(new UiExecute() {
					
					@Override
					public void onsucess() {
						
					}
					
					@Override
					public void onfailed() {
						isConnect=false;
						Toast.makeText(getApplicationContext(), getString(R.string.con_has_discon), 0).show();
					}
				});
			}
			
			@Override
			public void onfailed() {
				//连接失败后在UI线程中的执行
				isConnect=false;
				Toast.makeText(getApplicationContext(), getString(R.string.con_failed), 0).show();
				btnCon.setText(getString(R.string.con_failed));
			}
		});
	}
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode==0&&resultCode==RESULT_OK) {
			//通过去图库选择图片，然后得到返回的bitmap对象
			Uri selectedImage = data.getData();
//			String[] filePathColumn = { MediaStore.Images.Media.DATA };
//			Cursor cursor = getContentResolver().query(selectedImage,
//					filePathColumn, null, null, null);
//			cursor.moveToFirst();
//			int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
//			final String picturePath = cursor.getString(columnIndex);
//			cursor.close();
//			bitmap = BitmapFactory.decodeFile(picturePath);
//			String picturePath = PictureHelper.getPath(getApplicationContext(),
//					selectedImage);
			
//			BitmapFactory.Options options = new BitmapFactory.Options();
//			options.inPurgeable = true;
//
//			bitmap = BitmapFactory.decodeFile(picturePath, options);
			String picturePath = PictureHelper.getPath(getApplicationContext(),
					selectedImage);

			BitmapFactory.Options options = new BitmapFactory.Options();
			options.inPurgeable = true;
			final Bitmap bitmap;
			bitmap = BitmapFactory.decodeFile(picturePath, options);
//			bitmap = createViewBitmap(main);
			if(bitmap == null){
				Log.e("TEST BITMAP", "NULL  NULL  NULL  NULL");
			}
			
			
			binder.writeDataByYouself(new UiExecute() {

				@Override
				public void onsucess() {

				}

				@Override
				public void onfailed() {

				}
			}, new ProcessData() {//发送数据的处理和封装

						@Override
				public List<byte[]> processDataBeforeSend() {
					int paperWidth = 80;
					int paperHeight = 40;
					ArrayList<byte[]> list = new ArrayList<byte[]>();
					byte[] data0 = DataForSendToPrinterTSC.sizeBymm(paperWidth, paperHeight);
					list.add(data0);
					// 设置Gap,同上
					list.add(DataForSendToPrinterTSC.gapBymm(2, 0));
					// 清除缓存
					list.add(DataForSendToPrinterTSC.cls());

					list.add(DataForSendToPrinterTSC.bitmap(0, 0, 0, bitmap, BmpType.Dithering, (int) (paperWidth * 8),
							(int) (paperHeight * 8),true));
					Log.e("TEST BITMAP", bitmap.getHeight() + ":::::" + bitmap.getWidth());
					list.add(DataForSendToPrinterTSC.print(1));
					createFileWithByte(list);
					return list;
				}
					});
		}
		if (requestCode==1&&resultCode==RESULT_OK) {
			Uri selectedImage = data.getData();
			String picturePath = PictureHelper.getPath(getApplicationContext(),
					selectedImage);
			File pdf=new File(picturePath);
			final ArrayList<Bitmap>  bim=DataForSendToPrinterTSC.pdfToBitmap(pdf);
			binder.writeDataByYouself(new UiExecute() {

				@Override
				public void onsucess() {

				}

				@Override
				public void onfailed() {

				}
			}, new ProcessData() {//发送数据的处理和封装

						@Override
				public List<byte[]> processDataBeforeSend() {
					int paperWidth = 80;
					int paperHeight = 40;
					ArrayList<byte[]> list = new ArrayList<byte[]>();
					byte[] data0 = DataForSendToPrinterTSC.sizeBymm(paperWidth, paperHeight);
					list.add(data0);
					// 设置Gap,同上
					list.add(DataForSendToPrinterTSC.gapBymm(2, 0));
					Log.e("TEST pdf","pdf:"+bim.size());
					for(int i=0;i<bim.size();i++)
					{
						// 清除缓存
						list.add(DataForSendToPrinterTSC.cls());
						list.add(DataForSendToPrinterTSC.bitmap(0, 0, 0, bim.get(i), BmpType.Dithering, (int) (paperWidth * 8),
								(int) (paperHeight * 8),true));
						Log.e("TEST BITMAP", bim.get(i).getHeight() + ":::::" + bim.get(i).getWidth());
						list.add(DataForSendToPrinterTSC.print(1));
					}

					createFileWithByte(list);
					return list;
				}
					});
			
		}
		if (requestCode==Conts.ENABLE_BLUETOOTH&&resultCode==RESULT_OK) {
			showblueboothlist();  
		}
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		binder.disconnectCurrentPort(new UiExecute() {
			
			@Override
			public void onsucess() {
				
			}
			
			@Override
			public void onfailed() {
				
			}
		});
		unbindService(conn);
	}
	private void setlistener() {
		btn_scan.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				ll1.setVisibility(View.VISIBLE);
				//btn_scan.setVisibility(View.GONE);
			}
		});
		//已配对的设备的点击连接
		lv1.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				try {
					if(blueadapter!=null&&blueadapter.isDiscovering()){  
						blueadapter.cancelDiscovery();  

					}  

					String msg=deviceList_bonded.get(arg2);
					mac=msg.substring(msg.length()-17);
					String name=msg.substring(0, msg.length()-18);
					//lv1.setSelection(arg2);
					dialog.cancel();
					et.setText(mac);
					//Log.i("TAG", "mac="+mac);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
		//未配对的设备，点击，配对，再连接
		lv2.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				try {
					if(blueadapter!=null&&blueadapter.isDiscovering()){  
						blueadapter.cancelDiscovery();  

					}  
					String msg=deviceList_found.get(arg2);
					mac=msg.substring(msg.length()-17);
					String name=msg.substring(0, msg.length()-18);
					//lv2.setSelection(arg2);
					dialog.cancel();
					et.setText(mac);
					Log.i("TAG", "mac="+mac);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	
	private void findAvalibleDevice() {
		//获取可配对蓝牙设备  
		Set<BluetoothDevice> device=blueadapter.getBondedDevices();  

		deviceList_bonded.clear();  
		if(blueadapter!=null&&blueadapter.isDiscovering()){  
			adapter1.notifyDataSetChanged();  
		}  
		if(device.size()>0){ 
			//存在已经配对过的蓝牙设备  
			for(Iterator<BluetoothDevice> it=device.iterator();it.hasNext();){  
				BluetoothDevice btd=it.next();  
				deviceList_bonded.add(btd.getName()+'\n'+btd.getAddress());  
				adapter1.notifyDataSetChanged();  
			}  
		}else{  //不存在已经配对过的蓝牙设备  
			deviceList_bonded.add("No can be matched to use bluetooth");  
			adapter1.notifyDataSetChanged();  
		}  

	}
	/**
	 * byte数组拼接
	 * */
	private  byte[] byteMerger(byte[] byte_1, byte[] byte_2){  
        byte[] byte_3 = new byte[byte_1.length+byte_2.length];  
        System.arraycopy(byte_1, 0, byte_3, 0, byte_1.length);  
        System.arraycopy(byte_2, 0, byte_3, byte_1.length, byte_2.length);  
        return byte_3;  
    }  
	/** 
	 * 蓝牙搜索状态广播监听 
	 * 
	 * 
	 */  
	private class DeviceReceiver extends BroadcastReceiver{  

		@Override  
		public void onReceive(Context context, Intent intent) {  
			String action =intent.getAction();  
			if(BluetoothDevice.ACTION_FOUND.equals(action)){    //搜索到新设备  
				BluetoothDevice btd=intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);  
				//搜索没有配过对的蓝牙设备  
				if (btd.getBondState() != BluetoothDevice.BOND_BONDED) {  
					if (!deviceList_found.contains(btd.getName()+'\n'+btd.getAddress())) {

						deviceList_found.add(btd.getName()+'\n'+btd.getAddress()); 
						try {
							adapter2.notifyDataSetChanged();
						} catch (Exception e) {
							e.printStackTrace();
						}  
					}

				}  
			}  
			else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)){   //搜索结束  

				if (lv2.getCount() == 0) {  
					deviceList_found.add("No can be matched to use bluetooth");  
					try {
						adapter2.notifyDataSetChanged();
					} catch (Exception e) {
						e.printStackTrace();
					}  
				}  

			}  
		}     
	}  
	
//	class MyImageReceiver extends BroadcastReceiver {
//
//		@Override
//		public void onReceive(Context context, Intent intent) {
//			try {
//				String path = intent.getStringExtra("filePath");
//				bitmap = BitmapFactory.decodeFile(path);
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//		}
//
//	}
	
	private Bitmap createViewBitmap(View v) {
		Bitmap bitmap1 = Bitmap.createBitmap(640, 400, Bitmap.Config.ARGB_8888);
//		Bitmap bitmap1 = Bitmap.createBitmap(v.getWidth(), v.getHeight(), Bitmap.Config.ARGB_8888);
		Canvas canvas = new Canvas(bitmap1);
		v.draw(canvas);
//		bitmap1 = Bitmap.createScaledBitmap(bitmap1, bitmap1.getWidth(), bitmap1.getHeight(), true);
		return bitmap1;
	}
	
	
	/**
     * 根据byte数组生成文件
     * 
     * @param bytes
     *            生成文件用到的byte数组
     */
    private static void createFileWithByte(List<byte[]> bytes) {
        /**
         * 创建File对象，其中包含文件所在的目录以及文件的命名
         */
    	int length = 0;
        File file = new File("/sdcard",
                "test");
        // 创建FileOutputStream对象
        FileOutputStream outputStream = null;
        // 创建BufferedOutputStream对象
        BufferedOutputStream bufferedOutputStream = null;
        try {
            // 如果文件存在则删除
            if (file.exists()) {
                file.delete();
            }
            // 在文件系统中根据路径创建一个新的空文件
            file.createNewFile();
            // 获取FileOutputStream对象
            outputStream = new FileOutputStream(file);
            // 获取BufferedOutputStream对象
            bufferedOutputStream = new BufferedOutputStream(outputStream);
            // 往文件所在的缓冲输出流中写byte数据
            for(int i = 0; i < bytes.size(); i++){
            	bufferedOutputStream.write(bytes.get(i));
            	length = length + bytes.get(i).length;
            }
            Log.d("MSG", "LENGYH OF IMAGE DATA   " + length);
            // 刷出缓冲输出流，该步很关键，要是不执行flush()方法，那么文件的内容是空的。
            bufferedOutputStream.flush();
        } catch (Exception e) {
            // 打印异常信息
            e.printStackTrace();
        } finally {
            // 关闭创建的流对象
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (bufferedOutputStream != null) {
                try {
                    bufferedOutputStream.close();
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
            }
        }
    }
    
    
 // 数据接收处理
 	private void addReceiver() {
 		try {
 			binder.acceptDataFromPrinter(new UiExecute() {
 				@Override
 				public void onsucess() {
 				}

 				@Override
 				public void onfailed() {
 				}
 			});
 		} catch (Exception e) {
 			Log.e("error", e.getMessage());
 		}
 	}
//接收到的数据
 	private String msgReceiver = "";
	private String keyReceiver = "";
 	private HandlerThread thread;
 	private Handler receiverHandler;
 	private Handler toastHandler;
 	private Handler statusHandler;
 	private RoundQueue<byte[]> readReceiver() {
 		RoundQueue<byte[]> rq;
 		rq = binder.readBuffer();
 		return rq;
 	}

 	private void clearReceiver() {
 		binder.clearBuffer();
 	}
 	
 	
 	//示例指令, 详见TSPL指令集
	// 	OUT "DPI = ";GETSETTING$("SYSTEM","INFORMATION","DPI") 
	// 	OUT "MODEL = ";GETSETTING$("SYSTEM","INFORMATION","MODEL") 
	// 	OUT "SERIAL = ";GETSETTING$("SYSTEM","INFORMATION","SERIAL") 
	// 	OUT "VERSION = ";GETSETTING$("SYSTEM","INFORMATION","VERSION") 
	// 	OUT "CHECKSUM = ";GETSETTING$("SYSTEM","INFORMATION","CHECKSUM") 
	// 	OUT "MILAGE = ";GETSETTING$("SYSTEM","RECORD","MILAGE") 
	// 	OUT "CUT COUNTER = ";GETSETTING$("SYSTEM","RECORD","CUT COUNTER") 
	// 	OUT "DRAM CAPACITY = ";GETSETTING$("FILE","DRAM","CAPACITY") 
	// 	OUT "DRAM AVAILABLE = ";GETSETTING$("FILE","DRAM","AVAILABLE") 
	// 	OUT "FLASH CAPACITY = ";GETSETTING$("FILE","FLASH","CAPACITY") 
	// 	OUT "FLASH AVAILABLE = ";GETSETTING$("FILE","FLASH","AVAILABLE") 
	// 	OUT "CARD CAPACITY = ";GETSETTING$("FILE","CARD","CAPACITY") 
	// 	OUT "CARD AVAILABLE = ";GETSETTING$("FILE","CARD","AVAILABLE") 
	// 	OUT "CARD INSTALLED = ";GETSETTING$("FILE","CARD","INSTALLED") 
	// 	OUT "Ethernet MAC ADDRESS = ";GETSETTING$("CONFIG","NET","MAC ADDRESS") 
	// 	OUT "Ethernet IP ADDRESS = ";GETSETTING$("CONFIG","NET","IP ADDRESS") 
	// 	OUT "SENSOR TYPE = ";GETSETTING$("CONFIG","SENSOR","SENSOR TYPE") 
	// 	OUT "CARRIAGE = ";GETSETTING$("CONFIG","SENSOR","CARRIAGE") 
	// 	OUT "GAP INTENSION = ";GETSETTING$("CONFIG","SENSOR","GAP INTENSION") 
	// 	OUT "BLINE INTENSION = ";GETSETTING$("CONFIG","SENSOR","BLINE INTENSION") 
	// 	OUT "CONTINUOUS INTENSION = ";GETSETTING$("CONFIG","SENSOR","CONTINUOUS INTENSION") 
	// 	OUT "PRINT MODE = ";GETSETTING$("CONFIG","TSPL","PRINT MODE") 
	// 	OUT "DENSITY = ";GETSETTING$("CONFIG","TSPL","DENSITY") 
	// 	OUT "PAPER SIZE = ";GETSETTING$("CONFIG","TSPL","PAPER SIZE") 
	// 	OUT "GAP SIZE = ";GETSETTING$("CONFIG","TSPL","GAP SIZE") 
	// 	OUT "BLINE SIZE = ";GETSETTING$("CONFIG","TSPL","BLINE SIZE") 
	// 	OUT "DIRECTION = ";GETSETTING$("CONFIG","TSPL","DIRECTION") 
	// 	OUT "MIRROR = ";GETSETTING$("CONFIG","TSPL","MIRROR") 
	// 	OUT "RIBBON = ";GETSETTING$("CONFIG","TSPL","RIBBON") 
 	
 	
 	//STARTOFRECEIVER标记指令开始，ENDOFRECEIVER标记指令结束
 	// 	完整的查询指令为[OUT "STARTOFRECEIVERMODEL=";GETSETTING$("SYSTEM","INFORMATION","MODEL")"ENDOFRECEIVER"\r\n]
 	private String str = "OUT " + "\"" + "STARTOFRECEIVERMODEL=" + "\"" + ";GETSETTING$(" + "\"" + "SYSTEM" + "\"" + ","
			+ "\"" + "INFORMATION" + "\"" + "," + "\"" + "MODEL" + "\"" + ")+\"ENDOFRECEIVER\"\r\n";
 	//读取打印机型号，交互
 	private void getPrintModel(){
 		try {
			binder.write(DataForSendToPrinterTSC.strToData(str), new UiExecute() {
				@Override
				public void onsucess() {
				}

				@Override
				public void onfailed() {
				}
			});
		} catch (Exception e) {
			Log.e("error", e.getMessage());
		}
 	}
 	
 	//蓝牙接收处理
 	Runnable run = new Runnable() {
		@Override
		public void run() {
			while (true) {
				RoundQueue<byte[]> queue = readReceiver();
				if (queue.getLast() != null) {
					String s = null;
					Log.e("queue.getLast().length", ">>>>" + queue.getLast().length);
					Log.e("queue.getLast()", ">>>>" + bytesToHexString(queue.getLast()));
					if(queue.getLast().length == 1){
						byte[] status = queue.getLast();
						Log.e("status", bytesToHexString(status));
						Message message = Message.obtain();
						Bundle bundleData = new Bundle();
						if(status[0] == 0x00){
							bundleData.putString("status", "准备就绪");
							//结束状态查询
//							QueryStatus.closeQuery();
						}else if(status[0] == 0x01){
							bundleData.putString("status", "打印头开启");
						}else if(status[0] == 0x02){
							bundleData.putString("status", "纸张卡纸");
						}else if(status[0] == 0x03){
							bundleData.putString("status", "打印头开启并且纸张卡纸");
						}else if(status[0] == 0x04){
							bundleData.putString("status", "纸张缺纸");
						}else if(status[0] == 0x05){
							bundleData.putString("status", "打印头开启并且纸张缺纸");
						}else if(status[0] == 0x08){
							bundleData.putString("status", "无碳带");
						}else if(status[0] == 0x09){
							bundleData.putString("status", "打印头开启并且无碳带");
						}else if(status[0] == 0x10){
							bundleData.putString("status", "暂停");
						}else if(status[0] == 0x20){
							bundleData.putString("status", "打印中");
						}
						message.setData(bundleData);
						statusHandler.sendMessage(message);
					}else{
						try {
							s = new String(queue.getLast(), 0, queue.getLast().length, "utf-8");
							msgReceiver = msgReceiver + s;
							Log.e("RECEIVER  Runnable", "RECEIVER1 = " + s);
						} catch (UnsupportedEncodingException e) {
							e.printStackTrace();
						}
					}
					clearReceiver();
//					Log.e("RECEIVER  Runnable", "RECEIVER1 = " + s);
				}
				if (msgReceiver.contains("ENDOFRECEIVER")) {
					msgReceiver = msgReceiver.split("ENDOFRECEIVER")[0];
					msgReceiver = msgReceiver.split("STARTOFRECEIVER")[1];
					keyReceiver = msgReceiver.split("=")[0];
					msgReceiver = msgReceiver.split("=")[1];
					if (keyReceiver.equals("MODEL")) {
						Message message = Message.obtain();
						Bundle bundleData = new Bundle();
						bundleData.putString("key", msgReceiver);
						message.setData(bundleData);
						toastHandler.sendMessage(message);
					}
					msgReceiver = "";
				}
			}
		}
	};
	
	/**
	  * 数组转换成十六进制字符串
	  * @param byte[]
	  * @return HexString
	  */
	 public static final String bytesToHexString(byte[] bArray) {
	  StringBuffer sb = new StringBuffer(bArray.length);
	  String sTemp;
	  for (int i = 0; i < bArray.length; i++) {
	   sTemp = Integer.toHexString(0xFF & bArray[i]);
	   if (sTemp.length() < 2)
	    sb.append(0);
	   sb.append(sTemp.toUpperCase());
	  }
	  return sb.toString();
	 }
 	
 	@Override
    public void onLowMemory() {
        super.onLowMemory();
        unbindService(conn);
    }

	
}
