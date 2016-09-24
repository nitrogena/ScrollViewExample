//
//  ViewController.h
//  ScrollViewExample
//
//  Created by Jan Zelaznog on 29/08/15.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *baseFormFields;

// Los objetos UITextField se definen como properties, para que se pueda recuperar el texto escrito por el usuario
@property (nonatomic, strong) UITextField *nin;
@property (nonatomic, strong) UITextField *oin;
@property (nonatomic, strong) UITextField *firstName;
@property (nonatomic, strong) UITextField *middleName;
@property (nonatomic, strong) UITextField *lastName;
@property (nonatomic, strong) UITextField *ssn;
@property (nonatomic, strong) UITextField *address1;
@property (nonatomic, strong) UITextField *address2;
@property (nonatomic, strong) UITextField *zipcode;
@property (nonatomic, strong) UITextField *state;
@property (nonatomic, strong) UITextField *city;
@property (nonatomic, strong) UITextField *county;
@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) UITextField *phone;

@end

