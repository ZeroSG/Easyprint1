//
//  ViewController.m
//  ZiJiangPrinterDemo
//
//  Created by aduo on 5/30/16.
//
//

#import "ViewController.h"
#import "ZJPrinterSDK.h"
#import "PrinterListViewController.h"


@interface ViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    IBOutlet UIButton* _connectButton;
    IBOutlet UITextView* _textView;
    IBOutlet UIButton* _fontSizeButton;
    IBOutlet UIButton* _connectSetButton;
    IBOutlet UIButton* _printWidthButton;
    IBOutlet UISegmentedControl* _modeSegementedControl;
    
    NSInteger _fontSize;
    
    UIImagePickerController* _imagePicker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleZJPrinterConnectedNotification:) name:ZJPrinterConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleZJPrinterDisconnectedNotification:) name:ZJPrinterDisconnectedNotification object:nil];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    
    _connectButton.userInteractionEnabled = NO;
    _connectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _connectButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    _connectButton.titleLabel.minimumScaleFactor = 0.5f;
    _connectButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_connectButton setTitle:NSLocalizedString(@"NotConnected", @"NotConnected") forState:UIControlStateNormal];
    
    if (0 == _modeSegementedControl.selectedSegmentIndex)
    {
        [_connectSetButton setTitle:NSLocalizedString(@"SelectPrinter", @"SelectPrinter") forState:UIControlStateNormal];
    }
    else
    {
        [_connectSetButton setTitle:NSLocalizedString(@"ConnectIP", @"ConnectIP") forState:UIControlStateNormal];
    }
    
    [ZJPrinterSDK defaultZJPrinterSDK];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleZJPrinterConnectedNotification:(NSNotification*)notification
{
    if (!_connectButton.userInteractionEnabled)
    {
        double delayInSeconds = 1.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [[ZJPrinterSDK defaultZJPrinterSDK] printTestPaper];
        });
    }
    
    _connectButton.userInteractionEnabled = YES;
    [_connectButton setTitle:NSLocalizedString(@"Connected", @"Connected") forState:UIControlStateNormal];
}

- (void)handleZJPrinterDisconnectedNotification:(NSNotification*)notification
{
    _connectButton.userInteractionEnabled = NO;
    [_connectButton setTitle:NSLocalizedString(@"NotConnected", @"NotConnected") forState:UIControlStateNormal];
}

- (IBAction)disconnectButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] disconnect];
}

- (IBAction)connectSetButtonClicked:(id)sender
{
    if (0 == _modeSegementedControl.selectedSegmentIndex)
    {
        self.navigationController.navigationBarHidden = NO;
        
        PrinterListViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrinterListViewController"];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"InputIPAddress", @"InputIPAddress") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
        alertView.delegate = self;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView textFieldAtIndex:0].text = @"192.168.1.100";
        [alertView show];
    }
}

- (IBAction)printWidthButtonClicked:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:@"58mm", @"80mm", nil];
    sheet.tag = 3;
    [sheet showInView:self.view];
}

- (IBAction)printTextButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] printText:_textView.text];
}

- (IBAction)printTextImageButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] printTextImage:_textView.text];
}

- (IBAction)sendHexButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] sendHex:[_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (IBAction)codeBarButtonClicked:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:@"UPC-A", @"UPC-E", @"JAN13", @"JAN8", @"CODE39", @"ITF", @"CODABAR", @"CODE93", @"CODE128", nil];
    sheet.tag = 2;
    [sheet showInView:self.view];
}

- (IBAction)qrCodeButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] printQrCode:[_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (IBAction)cutPaperButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] cutPaper];
}

- (IBAction)beepButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] beep];
}

- (IBAction)openCasherButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] openCasher];
}

- (IBAction)printImageButtonClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else
    {
        UIAlertView* alertSheet = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"CameraPrivate", @"CameraPrivate") delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:nil, nil];
        [alertSheet show];
    }
    
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (IBAction)setFontSizeButtonClicked:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:@"1x", @"2x", @"3x", @"4x", nil];
    sheet.tag = 1;
    [sheet showInView:self.view];
}

- (IBAction)printTestPaperButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] printTestPaper];
}

- (IBAction)selfTestButtonClicked:(id)sender
{
    [[ZJPrinterSDK defaultZJPrinterSDK] selfTest];
}

-  (IBAction)segmentAction:(UISegmentedControl*)seg
{
    [[ZJPrinterSDK defaultZJPrinterSDK] disconnect];
    
    if (0 == _modeSegementedControl.selectedSegmentIndex)
    {
        [_connectSetButton setTitle:NSLocalizedString(@"SelectPrinter", @"SelectPrinter") forState:UIControlStateNormal];
    }
    else
    {
        [_connectSetButton setTitle:NSLocalizedString(@"ConnectIP", @"ConnectIP") forState:UIControlStateNormal];
    }
}

#pragma mark － UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField endEditing:YES];
    
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == actionSheet.tag)
    {
        if (4 == buttonIndex)
        {
            return;
        }
        
        _fontSize = buttonIndex;
        [_fontSizeButton setTitle:[NSString stringWithFormat:@"%@ (%ldx)", NSLocalizedString(@"FontSize", @"FontSize"), _fontSize+1] forState:UIControlStateNormal];
        
        [[ZJPrinterSDK defaultZJPrinterSDK] setFontSizeMultiple:_fontSize];
    }
    else if (2 == actionSheet.tag)
    {
        if (9 == buttonIndex)
        {
            return;
        }

        [[ZJPrinterSDK defaultZJPrinterSDK] printCodeBar:[_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] type:(CodeBarType)buttonIndex];
    }
    else if (3 == actionSheet.tag)
    {
        if (2 == buttonIndex)
        {
            return;
        }
        
        [_printWidthButton setTitle:0 == buttonIndex ? @"58mm" : @"80mm" forState:UIControlStateNormal];
        [[ZJPrinterSDK defaultZJPrinterSDK] setPrintWidth:0 == buttonIndex ? 384 : 576];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[ZJPrinterSDK defaultZJPrinterSDK] printImage:image];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [[ZJPrinterSDK defaultZJPrinterSDK] connectIP:[alertView textFieldAtIndex:0].text];
    }
}

@end