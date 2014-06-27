//
//  ViewController.m
//  stickyeyes
//
//  Created by John Paul Hayes on 25/06/2014.
//  Copyright (c) 2014 John Paul Hayes. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Device has no camera"
                                                    delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil];
        [alertView show];
    }
    
    self.stickyEyeOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sticky_eye.png"]];
    self.stickyEyeOne.frame = CGRectMake(50, 150, 100, 100);
    [self.stickyEyeOne setUserInteractionEnabled:YES];
    self.stickyEyeOne.tag = 101;
    self.stickyEyeOne.hidden = YES;
    [self.view addSubview:self.stickyEyeOne];
    [self.snap setImage:[UIImage imageNamed:@"camera-icon.png"] forState:UIControlStateNormal];
    
    self.stickyEyeTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sticky_eye.png"]];
    self.stickyEyeTwo.frame = CGRectMake(200, 100, 100, 100);
    [self.stickyEyeTwo setUserInteractionEnabled:YES];
    self.stickyEyeTwo.tag = 102;
    self.stickyEyeTwo.hidden = YES;
    [self.view addSubview:self.stickyEyeTwo];
    
    /*
     Originally I was adding the stickyEyeOne to the imageView.
     This prevented the abilty to get the tag for the view
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^void() {
        self.stickyEyeOne.hidden = NO;
        self.stickyEyeTwo.hidden = NO;
    }];

    [self printViewHierarchy:self.imageView depth:0];
}

- (IBAction)selectPhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^void(){
        self.stickyEyeOne.hidden = NO;
        self.stickyEyeTwo.hidden = NO;
    }];
}

- (IBAction)saveImage:(UIButton *)sender {

    CGImageRef photoImageRef = self.imageView.image.CGImage;
    CGFloat photoWidth = CGImageGetWidth(photoImageRef);
    CGFloat photoHeight = CGImageGetHeight(photoImageRef);
    // Get the location of the taken photo
    CGPoint photoPoint = [self.imageView frame].origin;
    CGPoint photoBasePoint = [self.imageView convertPoint:photoPoint toView:self.view];

    // Get the location of the first sticky eye
    CGPoint onePoint = [self.stickyEyeOne frame].origin;
    CGPoint oneBasePoint = [self.stickyEyeOne convertPoint:onePoint toView:[self.imageView superview]];
    
    // Get the location of the second sticky eye
    CGPoint twoPoint = [self.stickyEyeTwo frame].origin;
    CGPoint twoBasePoint = [self.stickyEyeTwo convertPoint:twoPoint toView:[self.imageView superview]];
    
    // build merged size
    CGSize mergedSize = CGSizeMake(photoWidth, photoHeight);

    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
    //Draw images onto the context
    [self.imageView.image drawInRect:CGRectMake(photoBasePoint.x, photoBasePoint.y, photoWidth, photoHeight)];
    [self.stickyEyeOne.image drawInRect:CGRectMake(oneBasePoint.x, oneBasePoint.y, 200, 200)];
    [self.stickyEyeTwo.image drawInRect:CGRectMake(twoBasePoint.x, twoBasePoint.y, 200, 200)];
    
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    NSLog(@"Saved new image to the default album");
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *choseImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = choseImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self.view bringSubviewToFront:[touch view]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([[touch view] tag] == 101 || [[touch view] tag] == 102){
        [[touch view] setCenter:[touch locationInView:self.view]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([[touch view] tag] == 101 || [[touch view] tag] == 102){
        [[touch view] setCenter:[touch locationInView:self.view]];
    }
}



- (void)printViewHierarchy:(UIImageView *)viewNode depth:(NSUInteger)depth
{
    for (UIImageView *v in viewNode.subviews)
    {
        NSLog(@"%@%@", [@"" stringByPaddingToLength:depth withString:@"|-" startingAtIndex:0], [v description]);
        if ([v.subviews count])
            [self printViewHierarchy:v depth:(depth + 2)]; // + 2 to make the output look correct with the stringPadding
    }
}

@end