//
//  DetailViewController.m
//  Homepwner
//
//  Created by Joe Conway on 10/26/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "AssetTypePicker.h"

@interface DetailViewController ()
{
    UIPopoverController *_imagePickerPopover;
}
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)showAssetTypePicker:(id)sender;

@end

@implementation DetailViewController

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil; }

- (void)viewDidLayoutSubviews
{
    for(UIView *v in [[self view] subviews]) {
        if([v hasAmbiguousLayout])
            NSLog(@"AMBIGUOUS: %@", v);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    [iv setContentMode:UIViewContentModeScaleAspectFit];
    [iv setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:iv];
    [self setImageView:iv];
    
    NSDictionary *nameMap = NSDictionaryOfVariableBindings(_imageView);
    NSArray *horizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_imageView]-5-|"
                                                options:0
                                                metrics:nil
                                                  views:nameMap];
    [[self view] addConstraints:horizontalConstraints];

    nameMap = NSDictionaryOfVariableBindings(_dateLabel, _imageView, _toolbar);
    NSArray *verticalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:
        @"V:|-131-[_dateLabel(==21)][_imageView][_toolbar(==44)]|"
                                                options:0
                                                metrics:nil
                                                  views:nameMap];

    [[self view] addConstraints:verticalConstraints];
}


- (void)setItem:(BNRItem *)item
{
    _item = item;
    [[self navigationItem] setTitle:[[self item] itemName]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    BNRItem *item = [self item];

    [[self nameField] setText:[item itemName]];
    [[self serialNumberField] setText:[item serialNumber]];
    [[self valueField] setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];

    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];

    // Use filtered NSDate object to set dateLabel contents
    // Convert time interval to NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[item dateCreated]];
    [[self dateLabel] setText:[dateFormatter stringFromDate:date]];

    NSString *imageKey = [[self item] imageKey];
    
    if (imageKey) {
        // Get image for image key from image store
        UIImage *imageToDisplay =
        [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        // Use that image to put on the screen in imageView
        [[self imageView] setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [[self imageView] setImage:nil];
    }
    
    NSString *typeLabel = [[[self item] assetType] valueForKey:@"label"];
    if (!typeLabel)
        typeLabel = @"None";
    
    [[self assetTypeButton] setTitle:[NSString stringWithFormat:@"Type: %@", typeLabel]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // Clear first responder
    [[self view] endEditing:YES];

    // "Save" changes to item
    BNRItem *item = [self item];
    [item setItemName:[[self nameField] text]];
    [item setSerialNumber:[[self serialNumberField] text]];
    [item setValueInDollars:[[[self valueField] text] intValue]];

}

- (IBAction)takePicture:(id)sender
{
    if ([_imagePickerPopover isPopoverVisible]) {
        // If the popover is already up, get rid of it
        [_imagePickerPopover dismissPopoverAnimated:YES];
        _imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController
            isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    // This line of code will generate a warning right now, ignore it
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        _imagePickerPopover = [[UIPopoverController alloc]
                               initWithContentViewController:imagePicker];
        [_imagePickerPopover setDelegate:self];
        // Display the popover controller; sender
        // is the camera bar button item
        [_imagePickerPopover presentPopoverFromBarButtonItem:sender
                                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                                    animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    _imagePickerPopover = nil;
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
    for(UIView *v in [[self view] subviews]) {
        if([v hasAmbiguousLayout]) {
            NSLog(@"%@", [v constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]);
            [v exerciseAmbiguityInLayout];
            return;
        }
    }
}

- (IBAction)showAssetTypePicker:(id)sender
{
    [[self view] endEditing:YES];
    
    AssetTypePicker *assetTypePicker = [[AssetTypePicker alloc] init];
    [assetTypePicker setItem:[self item]];
    
    [[self navigationController] pushViewController:assetTypePicker
                                           animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:[self dismissBlock]];
}


- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the BNRItem from the store
    [[BNRItemStore sharedStore] removeItem:[self item]];
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:[self dismissBlock]];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [[self item] imageKey];
    // Did the item already have an image?
    if (oldKey) {
        // Delete the old image
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }

    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [[self item] setThumbnailDataFromImage:image];
    
    // Create a NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    [[self item] setImageKey:key];
    // Store the image in the BNRImageStore for this key
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:[[self item] imageKey]];
    
    // Put that image onto the screen in our image view
    [[self imageView] setImage:image];
    // Take image picker off the screen -
    // you must call this dismiss method
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // If on the phone, the image picker is presented modally. Dismiss it.
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // If on the pad, the image picker is in the popover. Dismiss the popover.
        [_imagePickerPopover dismissPopoverAnimated:YES];
        _imagePickerPopover = nil;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            [[self imageView] setHidden:YES];
            [[self cameraButton] setEnabled:NO];
        } else {
            [[self imageView] setHidden:NO];
            [[self cameraButton] setEnabled:YES];
        }
    }
}


@end
