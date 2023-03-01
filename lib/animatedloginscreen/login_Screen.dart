import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'animation_enum.dart';

class loginScreen extends StatefulWidget {


  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsup;
  late RiveAnimationController controllerHandsdown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = 'ahmednagiub@gmail.com';
  String testPassword = '12345';
  final passwordFocusNode=FocusNode();

  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllControllers(){
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsup);
    riveArtboard?.artboard.removeController(controllerHandsdown);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerIdle);
    debugPrint('idleee');
  }

  void addHandUpController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsup);
    debugPrint('hand up');
  }
  void addHandDownController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsdown);
    debugPrint('hand Down');
  }
  void addsuccessController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerSuccess);
    debugPrint('success');
  }
  void addfailController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerFail);
    debugPrint('faillll');
  }
  void addLookLeftController(){
    removeAllControllers();
    isLookingLeft = true;
    riveArtboard?.artboard.addController(controllerLookLeft);
    debugPrint('Leftttttt');
  }
  void addLookRightController(){
    removeAllControllers();
    isLookingRight = true;
    riveArtboard?.artboard.addController(controllerLookRight);
    debugPrint('Righttttt');
  }

  void checkForPasswordFocusNodeToChangeAnimationState(){
    passwordFocusNode.addListener(() {
      if(passwordFocusNode.hasFocus){
        addHandUpController();
      }else if(!passwordFocusNode.hasFocus){
        addHandDownController();
      }
    });
  }


  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsup = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsdown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);

    rootBundle.load('assets/animation/animated_login_screen.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });
    checkForPasswordFocusNodeToChangeAnimationState();

  }

  void validateEmailAndPassword(){
    Future.delayed(const Duration(seconds: 1),(){
      if(formKey.currentState!.validate()){
        addsuccessController();
      }else{
        addfailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Animated Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: riveArtboard == null
                    ? const SizedBox.shrink()
                    : Rive(
                        artboard: riveArtboard!,
                      ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      validator: (value)=>
                      value != testEmail ? "Wrong Email" : null ,
                      onChanged: (value){
                        if(value.isNotEmpty && value.length < 14 && !isLookingLeft){
                          addLookLeftController();
                        }else if(value.isNotEmpty && value.length > 14 && !isLookingRight){
                          addLookRightController();
                        }
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/25),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                      validator: (value)=>
                      value != testPassword ? "Wrong Password" : null ,
                      focusNode: passwordFocusNode,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/18),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8),
                      child: TextButton(onPressed: (){
                        passwordFocusNode.unfocus();
                        validateEmailAndPassword();
                      },
                        style: TextButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 14),
                        ),
                          child: const Text(
                            'Log IN',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
