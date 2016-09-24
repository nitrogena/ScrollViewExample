//
//  ViewController.m
//  ScrollViewExample
//
//  Created by Jan Zelaznog on 29/08/15.
//
//

#import "ViewController.h"

// Se definen constantes, para tener un único punto donde se pueden ajustar los valores
// y no ensuciar el código poniendo literales

//ANCHOS FIJOS
#define SEPARATOR 10.0
#define MARGIN 25.0
#define LABEL_HEIGHT 24.0
#define TEXT_FIELD_HEIGHT 48.0
#define TEXT_FIELD_WIDTH 300.0


@implementation ViewController

BOOL tecladoArriba;

- (void)viewDidLoad {
    [super viewDidLoad];

    //PARA SABER SI TECLADO ESTA ARRIBA
    tecladoArriba = NO;
    // Utilizamos un objeto NSMutableArray, para agregar todos los textFields y luego poder recorrerlos
    self.baseFormFields = [[NSMutableArray alloc] init];
    
    // El objeto ScrollView, igual que todos los componentes, necesita un frame para colocarse en la vista
    // ALLOC PARA SOLICITAR MEMORIA
    // FRAME RECTANGULO QUE DEFINE TAMAÑO
    //X, Y ALTO Y ANCHO
    //ALTO DE LA PANTALLA MENOS UN MARGEN
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, MARGIN, self.view.bounds.size.width, self.view.bounds.size.height - MARGIN * 2) ];
    
    //AGREGA EL SCROLLVIEW
    //ALGO CREADO CON CODIGO SE DEBE CREAR A LA VISTA
    [self.view addSubview:self.scrollView];
    
    //ES UN METODO QUE SE INVOCA
    [self llenaScrollView];
}

- (void) viewWillAppear:(BOOL)animated {
    // El teclado es controlado por el Sistema Operativo, no por la aplicación, por eso necesitamos suscribirnos a las notificaciones
    // y así poder saber cuando aparece o desaparece y realizar las acciones necesarias
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tecladoAparece:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tecladoDesaparece:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    // Si la vista ya no está activa, no es necesario seguir recibiendo las notificaciones
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tecladoAparece:(NSNotification*)notification{
    if (tecladoArriba)
        return;
    // El objeto NSNotification tiene un objeto "userInfo" de tipo NSDictionary, donde podemos obtener información
    // especifica relacionada con el evento y objeto que generó la notificación
    NSDictionary* info = [notification userInfo];
    // En el caso de las notificaciones generadas por el teclado, debemos obtener el frame del teclado
    // para saber cuanto hay que ajustar el tamaño del contenido del scrollView
    NSValue* value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frameTeclado = [value CGRectValue] ;
    // Ajustamos el tamaño del contenido del scrollview, aumentando el tamaño del teclado
    // de modo que el usuario pueda alcanzar el ultimo textfield
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = self.scrollView.contentSize.height + frameTeclado.size.height;
    self.scrollView.contentSize = contentSize;
    tecladoArriba = YES;
}

- (void)tecladoDesaparece:(NSNotification*)notification{
    // El objeto NSNotification tiene un objeto "userInfo" de tipo NSDictionary, donde podemos obtener información
    // especifica relacionada con el evento y objeto que generó la notificación
    NSDictionary* info = [notification userInfo];
    // En el caso de las notificaciones generadas por el teclado, debemos obtener el frame del teclado
    // para saber cuanto hay que ajustar el tamaño del contenido del scrollView
    NSValue* value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frameTeclado = [value CGRectValue];
    // Ajustamos el tamaño del contenido del scrollview, reduciendo el tamaño del teclado
    // de modo que el contenido vuelva a su tamaño original
    // en este caso lo hacemos con una animación, para que
    // no se vea un "brinco" si esta visible el ultimo textfield
    [UIView animateWithDuration:0.2 animations:^{
        CGSize contentSize = self.scrollView.contentSize;
        contentSize.height = self.scrollView.contentSize.height - frameTeclado.size.height;
        self.scrollView.contentSize = contentSize;
    } completion:^(BOOL finished) {
        tecladoArriba = NO;
    }];
}

- (void) llenaScrollView {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //ES UN OBJETO UILabel, TODAS LAS ETIQUETAS SON CREADAS AL MISMO TIEMPO,
    
    UILabel *label = [self etiquetaConFrame:CGRectMake(SEPARATOR, SEPARATOR, TEXT_FIELD_WIDTH, LABEL_HEIGHT)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText: @"Personal Information:"];
    [self.scrollView addSubview:label];
    
    self.firstName = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(label.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)  yPlaceHolder: @"Name" ];
    self.firstName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self.scrollView addSubview:self.firstName];
    
    self.middleName = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.firstName.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"Middle Name" ];
    self.middleName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self.scrollView addSubview:self.middleName];
    
    self.lastName = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.middleName.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"Last Name" ];
    self.lastName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self.scrollView addSubview:self.lastName];
    
    self.ssn = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.lastName.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"Social Security Number" ];
    self.ssn.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.ssn];
    
    UILabel *label2 = [self etiquetaConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.ssn.frame) + SEPARATOR * 2, TEXT_FIELD_WIDTH, LABEL_HEIGHT)];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setText: @"Billing Address:" ];
    [self.scrollView addSubview:label2];
    
    self.address1 = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(label2.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"Address 1" ];
    [self.scrollView addSubview:self.address1];

    self.address2 = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.address1.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"Address 2" ];
    [self.scrollView addSubview:self.address2];

    self.zipcode = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.address2.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"Zip" ];
    self.zipcode.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.zipcode];

    self.state = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.zipcode.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"State" ];
    [self.scrollView addSubview:self.state];
    
    self.city = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.state.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"City" ];
    [self.scrollView addSubview:self.city];
 
    self.county = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.city.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"County" ];
    [self.scrollView addSubview:self.county];

    UILabel *label3 = [self etiquetaConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.county.frame) + SEPARATOR * 2, TEXT_FIELD_WIDTH, LABEL_HEIGHT)];
    [label3 setTextAlignment:NSTextAlignmentLeft];
    [label3 setText: @"Contact information" ];
    [self.scrollView addSubview:label3];
    
    self.phone = [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(label3.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"Phone Number" ];
    [self.phone setKeyboardType:UIKeyboardTypePhonePad];
    [self.scrollView addSubview:self.phone];
    
    self.email =  [self creaTextFieldConFrame:CGRectMake(SEPARATOR, CGRectGetMaxY(self.phone.frame) + SEPARATOR, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT) yPlaceHolder: @"Email" ];
    self.email.keyboardType = UIKeyboardTypeEmailAddress;
    [self.email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.email setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.email setReturnKeyType:UIReturnKeyDone];
    [self.scrollView addSubview:self.email];

    // El aspecto importante para que funcione correctamente el objeto UIScrollView, es establecer el tamaño de su contenido
    // si el contentSize del scrollView, fuera igual a su frame.size entonces no habría scroll (no sería necesario)
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.email.frame) + SEPARATOR)];

    // El objeto UITapGestureRecognizer, se puede agregar a cualquier objeto en la vista que normalmente no responde al
    // evento touch, como un imageView. En este caso agregamos el objeto tap para identificar cuando el usuario toca "el fondo"
    // de la vista, y entonces ocultar el teclado
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tap setCancelsTouchesInView:NO];
    [self.scrollView addGestureRecognizer:tap];
}

- (void)handleTap:(id) recognizer {
    // Si el usuario toca en la vista, fuera de cualquier textField, se busca cual de los textField's tiene el foco
    // para liberarlo y ocultar el teclado
    for (int ix = 0; ix < self.baseFormFields.count; ix++) {
        if ([[self.baseFormFields objectAtIndex:ix] isFirstResponder])
            [[self.baseFormFields objectAtIndex:ix] resignFirstResponder];
    }
}


///// ***** ///// ***** ///// ***** ///// ***** /////
// Métodos auxiliares para crear los componentes

- (UILabel *)etiquetaConFrame:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 2;
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor clearColor];
    
    //SOMBREADO DEL TEXTO, DESFAZADA UN PIXEL A LA DERECHA Y HACIA ABAJO
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1);
    return label;
}

//TODOS CUADROS DE TEXTO SE CREAN AQUI
- (UITextField *) creaTextFieldConFrame:(CGRect) rect yPlaceHolder:(NSString *)placeHolder {
    UITextField *tmp = [[UITextField alloc] initWithFrame:rect];
    
    //OTRO OBJETO SE HARA CARGO
    tmp.delegate = self;
    [tmp setPlaceholder:placeHolder];
    //COMO SE MUESTRA TECLADO, LA TECLA "SIGUIENTE", PARA BAJARLA AL SIGUIENTE CAMPO, NO ESTA IMPLEMENTADA
    [tmp setReturnKeyType:UIReturnKeyNext];
    //COLOR DE TEXTO INGRESADO POR USUARIO
    [tmp setTextColor:[UIColor whiteColor]];
    //FONDO DE CUADRO TEXTO, LOS COLORES SON OBJETOS
    [tmp setBackgroundColor:[UIColor cyanColor]];
    //CUADROS SE METEN A UN ARREGLO, QUE ESTA DECLARADO ARRIBA COMO MUTABLE (SE AGREGAN MAS OBJ. EN TIEMPO DE EJECUCION)
    [self.baseFormFields addObject:tmp];
    return tmp;
}
///// ***** ///// ***** ///// ***** ///// ***** /////

@end
