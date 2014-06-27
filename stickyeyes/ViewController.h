//
//  ViewController.h
//  stickyeyes
//
//  Created by John Paul Hayes on 25/06/2014.
//  Copyright (c) 2014 John Paul Hayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *stickyEyeOne;
@property (strong, nonatomic) IBOutlet UIImageView *stickyEyeTwo;
@property (strong, nonatomic) IBOutlet UIButton *snap;
- (IBAction)takePhoto:(UIImageView *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)saveImage:(UIButton *)sender;
@end
