//
//  LoginViewController.m
//  PrizeKing
//
//  Created by Andres Abril on 18/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end


#define kInitialBalance 5000
#ifdef UI_USER_INTERFACE_IDIOM
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (false)
#endif
#ifdef UI_USER_INTERFACE_IDIOM
#define IS_IPHONE() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#else
#define IS_IPHONE() (false)
#endif
/*
 //Lista de requests para el server
/GetActiveAuctionsLight/{auctionID}     
/GetLastAuctions/{countAuctions} 
/CreateBID/{auctionId}/{amount}/{user}
/ChargeCoinsUser/{amount}/{user}/{extra1}/{extra2}
/CreateUser/{balance}/{facebookId}/{firstName}/{lastName}/{image}/{mail}/{deviceToken}/{isDummy}
/ExistsUser/{facebookId}
/CreateUserDevice/{id}/{facebookID}
/DeleteUserDevices/{facebookID}
 /GetTestimonials/{count}
 */
@implementation LoginViewController

@synthesize facebook;

- (void)viewDidLoad{
    [super viewDidLoad];
    //[self logicTest:700];
    mVC=[[MainMenuViewController alloc]init];
    mVC=[self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFacebookData:) name:@"requestFacebookData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"loguedout" object:nil];
    file=[[FileSaver alloc]init];
    deviceToken=[file getDeviceToken];
    if ([deviceToken isEqualToString:@"null"]) {
        NSLog(@"device token in Login %@",deviceToken);
        deviceToken=@"nd";
    }
    loadingLabel.text=@"";
    friendsList=[[NSMutableArray alloc]init];
    friendsListInstalled=[[NSMutableArray alloc]init];
    friendsListNOTInstalled=[[NSMutableArray alloc]init];
    
    spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.frame=CGRectMake(self.view.frame.size.height/2-10, self.view.frame.size.width/8-10, 20, 20);
    [self.view addSubview:spinner];
    server=[[ServerCommunicator alloc]init];
    server.caller = self;
    peticion=0;
    //[self eraseTokensFromUser];
}    
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"requestFacebookData" object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"loguedout" object:nil];

    [self spinnerStop];
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFacebookData:) name:@"requestFacebookData" object:nil];
    [self deleteFacebookArrays];
}
-(void)update{
    [self deleteFacebookArrays];
    [[Facebook shared] requestWithGraphPath:@"me" andDelegate:self];
    loadingLabel.text=@"Loading user data";
    NSThread *bThread=[[NSThread alloc]initWithTarget:self selector:@selector(spinnerStart) object:nil];
    [bThread start];
    [loginButton setEnabled:NO];
    //call a legacy REST API
    //NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"1", @"uids", @"name", @"fields", nil];
    
    //[[Facebook shared] requestWithMethodName: @"users.getInfo" andParams: params andHttpMethod: @"GET" andDelegate: self];
}
- (void)requestLoading:(FBRequest *)request{
    NSLog(@"req loading");
}
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"req received response");
}
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"req %@ failed error %@",request,error);
    [self spinnerStop];
}
-(void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"Inside didLoad");
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if ([result isKindOfClass:[NSDictionary class]]){
        //NSLog(@"result %@",result);
        
        //Si el resultado de facebook contiene el campo name significa que el usuario existe y fue descargado
        if ([result objectForKey:@"name"]) {
            NSString *imageUrlNoEncode=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]];
            //Codificacion de la url para ser enviada al servicio por REST
            imageURL=[IAmCoder encodeURL:imageUrlNoEncode];
            NSLog(@"image url encoded %@",imageURL);

            //Carlos ramos hard coded
            /*facebookId=@"699407780";//[result objectForKey:@"id"];
            firstName=@"Carlos";//[result objectForKey:@"first_name"];
            lastName=@"Ramos";//[result objectForKey:@"last_name"];
            eMail=@"carlos.ramos@gmail.com";//[result objectForKey:@"email"];*/
            
            //Nathaly hard coded
            /*facebookId=@"679528033";//[result objectForKey:@"id"];
            firstName=@"Nathaly";//[result objectForKey:@"first_name"];
            lastName=@"Abril";//[result objectForKey:@"last_name"];
            eMail=@"nathys@gmail.com";//[result objectForKey:@"email"];*/
            
            //Usuario de facebook sin hardcode
            facebookId=[result objectForKey:@"id"];
            firstName=[result objectForKey:@"first_name"];
            lastName=[result objectForKey:@"last_name"];
            eMail=[result objectForKey:@"email"];
            
            //[[Facebook shared] requestWithGraphPath:@"me/friends" andDelegate:self];
            [[Facebook shared] requestWithGraphPath:@"me/friends?fields=installed,name" andDelegate:self];
            loadingLabel.text=[NSString stringWithFormat:@"Processing data..."];
        }
        
        //Si el resultado de facebook contiene el campo data significa que la lista de amigos fue descargada
        if ([result objectForKey:@"data"]) {
            //NSLog(@"Friends: %@", [result objectForKey:@"data"]);

            //Creamos lista de objetos friend basado en la respuesta individual de cada amigo
            for (int i=0; i<[[result objectForKey:@"data"] count]; i++) {
                if ([[[result objectForKey:@"data"]objectAtIndex:i]objectForKey:@"installed"]) {
                    Friend *friend=[[Friend alloc]init];
                    friend.name=[[[result objectForKey:@"data"]objectAtIndex:i]objectForKey:@"name"];
                    friend.ID=[[[result objectForKey:@"data"]objectAtIndex:i]objectForKey:@"id"];
                    friend.installed=[[[result objectForKey:@"data"]objectAtIndex:i]objectForKey:@"installed"];
                    [friendsListInstalled addObject:friend];
                }
                else{
                    Friend *friend=[[Friend alloc]init];
                    friend.name=[[[result objectForKey:@"data"]objectAtIndex:i]objectForKey:@"name"];
                    friend.ID=[[[result objectForKey:@"data"]objectAtIndex:i]objectForKey:@"id"];
                    friend.installed=@"0";
                    [friendsListNOTInstalled addObject:friend];
                }
                Friend *friend=[[Friend alloc]init];
                friend.name=[[[result objectForKey:@"data"]objectAtIndex:i]objectForKey:@"name"];
                friend.ID=[[[result objectForKey:@"data"]objectAtIndex:i]objectForKey:@"id"];
                [friendsList addObject:friend];
                loadingLabel.text=[NSString stringWithFormat:@"Loading %@",friend.name];
                NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
                [friendsList sortUsingDescriptors:[NSMutableArray arrayWithObjects:alphaDesc, nil]];
            }
            //esta sección se encarga de descargar todas las imágenes de los amigos de facebook y las guarda en cache
            for (Friend *friend in friendsList){
                NSString *friendUrl=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small",friend.ID];
                [CacheImage getCachedImage:friendUrl];
            }
            //fin de la sección//
            
            [self comprobarUsuario];
        }
    }
    if ([result isKindOfClass:[NSData class]])
    {
        NSLog(@"Profile Picture");
        //[profilePicture release];
        //profilePicture = [[UIImage alloc] initWithData: result];
    }
    //[[Facebook shared] dialog:@"feed" andDelegate:self];
    //NSLog(@"request returns %@",result);
}
-(void)requestFacebookData:(NSNotification*)notification {
    NSLog(@"request fb data");
    //[[Facebook shared] requestWithGraphPath:@"me/friends" andDelegate:self];
    [self update];
}
-(void)FBDidLogout{
    
}
-(IBAction)updateTrigger:(id)sender{
    [Facebook niler];
    [self update];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
            (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
-(void)spinnerStart{
    [spinner startAnimating];
}
-(void)spinnerStop{
    [spinner stopAnimating];
}
-(IBAction)logout:(id)sender{
    NSLog(@"requested by notification center");
    [[Facebook shared]logout:self];
}
-(void)comprobarUsuario{
    if (facebookId) {
        peticion=1;
        loadingLabel.text=@"Veryfing user...";
        [server callServerWithMethod:@"ExistsUser" andParameter:facebookId];
    }
}
-(void)crearUsuario{
    peticion=2;
    loadingLabel.text=[NSString stringWithFormat:@"Registering user..."];
    [file setCoinsQuantity:kInitialBalance];
    NSString *parameters=[NSString stringWithFormat:@"%.0f/%@/%@/%@/%@/%@/%@/%@/%@/%@",[file getCoinsQuantity],facebookId,firstName,lastName,imageURL,eMail,deviceToken,@"false",@"0",@"true"];
    // /CreateUser/{balance}/{facebookId}/{firstName}/{lastName}/{image}/{mail}/{deviceToken}/{isDummy}
    [server callServerWithMethod:@"CreateUser" andParameter:parameters];
}
-(void)crearDevice{
    peticion=3;
    loadingLabel.text=@"Adding user device...";
    NSString *parameters=[NSString stringWithFormat:@"%@/%@/%@",deviceToken,facebookId,@"0"];
    ///CreateUserDevice/{id}/{facebookID}/{isActiveUser}
    NSLog(@"creando device con token %@ y facebookId %@",deviceToken, facebookId);
    [server callServerWithMethod:@"CreateUserDevice" andParameter:parameters];
}
-(void)eraseTokensFromUser{
     //DeleteUserDevices/{facebookID}
    NSLog(@"facebook id antes del delete %@",facebookId);
    [server callServerWithMethod:@"DeleteUserDevices" andParameter:@"657931188"];
}
-(void)resetVariables{
    imageURL=@"";    
    facebookId=@"";
    firstName=@"";
    lastName=@"";
    eMail=@"";
}
#pragma mark - server response
-(void)receivedDataFromServerWithError:(id)sender{
    peticion=0;
    NSLog(@"Error");
    loadingLabel.text=@"An Error has occurred.";
    [self spinnerStop];
    [self resetVariables];
}
-(void)receivedDataFromServer:(id)sender{
    server=sender;
    NSLog(@"check %@",server.resDic);
    
    //Si la petición al server es = 1 nos encontramos comprobando la existencia del user
    if (peticion==1) {
        BOOL exists=[[server.resDic objectForKey:@"Exists"]boolValue];
        
        //Si el usuario existe
        if (exists) {
            NSLog(@"Existe");
            int noEsta=0;
           
            //Si el user no autorizó al OS de capturar el device token se prosigue a construir el objeto y no enviar devices al server
            if ([deviceToken isEqualToString:@"nd"]) {
                NSDictionary *userDic=server.resDic;
                User *user=[[User alloc]initUserWithDictionary:userDic andDeviceToken:@"nd"];
                user.friendsList=friendsList;
                user.friendsListInstalled=friendsListInstalled;
                user.friendsListNOTInstalled=friendsListNOTInstalled;
                mVC.user=user;
                peticion=0;
                [self.navigationController pushViewController:mVC animated:YES];
                [self spinnerStop];
                [self resetVariables];
                [loginButton setEnabled:YES];
            }
            
            //Si No existe device token
            else{
                
                //Comprobamos que esté llegando un arreglo
                if ([[server.resDic objectForKey:@"Devices"] isKindOfClass:[NSArray class]]) {
                    
                    //Iniciamos un arreglo con la respuesta de devices de ese usuario
                    NSArray *arrayOfDevices=[server.resDic objectForKey:@"Devices"];
                    NSLog(@"Array existe");
                    
                    //Comprobamos si el device token ya está inscrito 
                    for (int i=0; i< arrayOfDevices.count; i++) {
                        if ([deviceToken isEqualToString:[NSString stringWithFormat:@"%@",[arrayOfDevices objectAtIndex:i]]]){noEsta=noEsta;}
                        else{noEsta++;}
                        NSLog(@"campo %i array %@ y el DeviceToken es %@",i,[arrayOfDevices objectAtIndex:i],deviceToken);
                    }
                    
                    //Si no está inscrito se inscribirá y se comprobará
                    if (noEsta==arrayOfDevices.count) {
                        NSLog(@"Y no estuvo %i %i",noEsta,arrayOfDevices.count);
                        [self crearDevice];
                        return;
                    }
                    
                    //Si está inscrito se crea el objeto user local con el objeto user del server
                    else{
                        NSDictionary *userDic=server.resDic;
                        User *user=[[User alloc]initUserWithDictionary:userDic andDeviceToken:deviceToken];
                        user.friendsList=friendsList;
                        user.friendsListInstalled=friendsListInstalled;
                        user.friendsListNOTInstalled=friendsListNOTInstalled;
                        mVC.user=user;
                        peticion=0;
                        [self.navigationController pushViewController:mVC animated:YES];
                        [self spinnerStop];
                        [self resetVariables];
                        [loginButton setEnabled:YES];
                    }
                }
                //Si lo que llega no es un arreglo quiere decir que está vacío y hay que crear el device con el token
                else{
                    NSLog(@"Array No existe");
                    [self crearDevice];
                }
            }
        }
        //Si el user no existe se crea uno nuevo
        else{
            NSLog(@"No existe");
            [self crearUsuario];
        }
    }
    //Si la petición al server es = 2 nos encontramos creando un nuevo usuario
    else if(peticion==2){
        NSLog(@"peticion 2");
        NSDictionary *userDic=server.resDic;
        BOOL exists=[[server.resDic objectForKey:@"Exists"]boolValue];
        //Si la respuesta del servidor existe creamos el user y vamos al siguiente VC
        if (exists) {
            NSLog(@"Hay user");
            User *user=[[User alloc]initUserWithDictionary:userDic andDeviceToken:deviceToken];
            user.friendsList=friendsList;
            user.friendsListInstalled=friendsListInstalled;
            user.friendsListNOTInstalled=friendsListNOTInstalled;
            mVC.user=user;
            peticion=0;
            [self.navigationController pushViewController:mVC animated:YES];
            [self spinnerStop];
            [self resetVariables];
            [loginButton setEnabled:YES];
        }
        //Si la respuesta del server no existe no se creará usuario
        else{
            NSLog(@"Error creando el user");
            [self spinnerStop];
            [self resetVariables];
            [loginButton setEnabled:YES];
            peticion=0;
        }
    }
    //Si la petición al server es = 3 nos encontramos creando un nuevo dispositivo para el usuario existente
    else if(peticion==3){
        NSLog(@"peticion 3");
        [self comprobarUsuario];
        NSLog(@"res dic %@",server.resDic);
    }
    loadingLabel.text=@"";
}

-(void)deleteFacebookArrays{
    [friendsListInstalled removeAllObjects];
    [friendsListNOTInstalled removeAllObjects];
    [friendsList removeAllObjects];
}

-(void)logicTest:(int)cost{
    int transactionCost=cost;
    int free=1000;
    int ad=500;
    int bought=0;
    int total=free+ad+bought;
    int counter=cost;
    if (total>=transactionCost){
        if (bought>=transactionCost){
            counter=0;
            bought-=transactionCost;
            NSLog(@"Alcanzó en la primera Total free %i ad %i bought %i",free,ad,bought);
        }
        else{
            counter-=bought;
            bought=0;
            if (counter>0){
                if (ad>=counter){
                    ad-=counter;
                    counter=0;
                    NSLog(@"Alcanzó en la segunda Total free %i ad %i bought %i",free,ad,bought);
                }
                else{
                    counter-=ad;
                    ad=0;
                    if (counter>0){
                        if (free>=counter){
                            free-=counter;
                            counter=0;
                            NSLog(@"Alcanzó en la tercera Total free %i ad %i bought %i",free,ad,bought);
                        }
                        else{
                            NSLog(@"No alcanzó Total free %i ad %i bought %i",free,ad,bought);
                        }
                    }
                }
            }
        }
    }
    else{
        NSLog(@"No alcanzó la plata inicial Total free %i ad %i bought %i",free,ad,bought);
    }
}

@end
