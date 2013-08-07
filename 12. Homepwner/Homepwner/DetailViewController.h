//
//  DetailViewController.h
//  Homepwner
//
//  Created by Joe Conway on 10/26/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) BNRItem *item;

@end
