// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

// pragma ComponentBehavior: Bound

import QtQuick
import QtQuick3D
import QtQuick3D.Particles3D
import QtQuick3D.Helpers
import QtQuick.Controls
import QtQuick3D.Physics
// import Qt3D.Render

Window {
    id: rootWindow

    // readonly property url startupView: "StartupView.qml"

    width: 400
    height: 420
    visible: true
    title: qsTr("Qt Quick 3D Particles3D Testbed")
    color: "#000000"
        // Background ocean gradient
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    color: "#005060"
                    position: 0.0
                }
                GradientStop {
                    color: "#000000"
                    position: 1.0
                }
            }
        }
        Button{
            width:299
            height:45
            text:"Minecraft"
            anchors.left: parent.left
            anchors.top:parent.top
            z:Infinity
            anchors.leftMargin:39
            anchors.topMargin: 39
        }

        PhysicsWorld {
            id: physicsWorld
            running: true
            scene: view.scene
        }
        View3D {
            id:view
            anchors.fill: parent
            environment: SceneEnvironment {
                clearColor: "skyblue"
                backgroundMode: SceneEnvironment.Color
            }
            // environment: SceneEnvironment {
            //     backgroundMode: SceneEnvironment.Transparent
            //     antialiasingMode: AppSettings.antialiasingMode
            //     antialiasingQuality: AppSettings.antialiasingQuality
            // }

            // camera: camera

            DirectionalLight {
                eulerRotation.x: -88
                eulerRotation.y: -30
                eulerRotation.z:-20
                // shadowFactor: 10
                // castsShadow: true
                // shadowMapQuality: Light.ShadowMapQualityHigh
                ambientColor: "#909090"
            }


            // DirectionalLight {
            //     eulerRotation.x: -60+180
            //     eulerRotation.y: -10
            //     eulerRotation.z:-20
            //     brightness: 0.4
            //     // eulerRotation.z:20
            //     // shadowFactor:0
            //     // castsShadow: true
            // }

            // DirectionalLight {
            //     // x: 400
            //     // y: 1200
            //     bakeMode: Light.BakeModeIndirect
            //     eulerRotation.x: -60
            //     // castsShadow: true
            //     // shadowMapQuality: Light.ShadowMapQualityHigh
            //     shadowFactor: 50
            //     // quadraticFade: 2
            //     ambientColor: "#202020"
            //     // brightness: 200
            // }


            // Node {
            //     id: originNode




                Component {
                    id: blockComponent

                    Model {
                        id: block
                        source: "#Cube"
                        scale: Qt.vector3d(1,1,1)
                        pickable:true

                        property real breakProgress: 0.0
                        property bool isBreaking: false
                        materials:CustomMaterial {
                            id:customMaterial

                            fragmentShader: "images/block.frag"

                            // // Enable lighting calculations
                            // shadingMode: CustomMaterial.Shaded


                            property real progress: block.breakProgress
                            property TextureInput baseTexture: TextureInput{
                                texture:Texture {
                                    source: "images/mc.jpg"
                                    magFilter: Texture.Nearest

                                }

                            }

                            property TextureInput crackTexture: TextureInput{
                                enabled:false
                                texture:Texture {
                                    source:''
                                    magFilter: Texture.Nearest
                                }
                            }
                        }

                        StaticRigidBody {
                            // position: Qt.vector3d(-100, 100, 0)
                            collisionShapes: BoxShape {
                                id: boxShape
                            }
                        }

                        PropertyAnimation {
                                  id: breakAnimation
                                  target: block
                                  property: "breakProgress"
                                  from: 0.0
                                  to: 0.9
                                  duration: 500 // Adjust this value to change breaking speed
                                  running: block.isBreaking
                              }

                              onBreakProgressChanged: {
                                  if (breakProgress >= 0.9) {

                                      minningAnimation.stop()
                                      destroy()
                                  } else {
                                      customMaterial.crackTexture.texture.source = "images/breaking/destroy_stage_" + Math.floor(breakProgress * 10) + ".png"

                                  }
                              }

                              function startBreaking() {
                                  isBreaking = true
                                  customMaterial.crackTexture.enabled=true
                                  breakAnimation.start()
                                  minningAnimation.start()
                              }

                              function stopBreaking() {
                                  isBreaking = false
                                  customMaterial.crackTexture.enabled=false
                                  breakAnimation.stop()
                                  minningAnimation.stop()
                                  breakProgress = 0.0
                              }

                    }

                }

            // }




            CharacterController {
                id: character
                //! [position]
                property vector3d startPos: Qt.vector3d(0, 200, 0)
                position: startPos
                //! [position]
                onPositionChanged: {
                    if(position.y<-1000){
                         character.teleport(character.startPos)
                    }


                    // onForwardSpeedChanged:   {
                        // console.log(character.position.y- character.characterHeight/2 )
                        if(controllers.forceStop===0){
                            return
                        }

                        // if(movement===Qt.vector3d(0,0,0)){
                        //     forceStop=1
                        //     console.log("movement is 0")
                        //     return
                        // }

                        if(controllers.crouchActive){
                            // movement=Qt.vector3d(0,0,0)
                            // console.log(Qt.vector3d(character.positon.x + forwardSpeed  ))
                            // var pos= Qt.vector3d( (-Math.abs(character.position.x)/character.position.x)*25 + character.position.x, 100, (-Math.abs(character.position.z)/character.position.z)*25 + character.position.z);
                            // // // if(Math.floor(pos.x/100)>)

                            var newpos = Qt.vector2d(character.position.x -(Math.trunc(character.position.x/100)*100 + (character.position.x >=0 ? 1:-1)*50 ),character.position.z- (Math.trunc(character.position.z/100)*100 + (character.position.z >=0 ? 1:-1)*50 ) );
                            function isInside(){
                                return Math.abs(newpos.y +newpos.x) + Math.abs(newpos.y-newpos.x) <= 2* (32);
                            }

                            // -!- important : x = ^ && z= >


                            // console.log(isInside())
                            // console.log("position : " + character.position)
                            // console.log("pos : " + pos)

                            var c = controllers.moveForwards ? character.forward :controllers.moveBackwards?Qt.vector3d(-character.forward.x,0,-character.forward.z):controllers.moveRight ? character.right : controllers.moveLeft?Qt.vector3d(-character.right.x,0,-character.right.z):Qt.vector3d(0,0,0);
                            // console.log(c)

                            // var result0 = view.rayPick(character.position,Qt.vector3d(0,-1,0))
                            // if(!((result0.objectHit && result0.distance>=100)|| (!result0.objectHit))){
                            //     controllers.forceStop=1
                            //     return
                            // }
                            // console.log("forward : " + character.forward)
                            var t = Qt.vector3d(character.position.x -15*c.x,character.position.y,character.position.z -15*c.z)
                            var result = view.rayPick(t,Qt.vector3d(0,-1,0))
                            if((result.objectHit && result.distance>=100)|| (!result.objectHit)){
                                // movement=Qt.vector3d(0,0,0)
                                // if(Math.abs(newpos.x)>)
                                // if(isInside()){
                                    // moveForwards =0
                                    // moveBackwards=0
                                    // movement=Qt.vector3d(0,0,0)
                                    controllers.forceStop=0.001
                                    console.log("you will fall")
                                // }


                            }else{
                                controllers.forceStop=1
                            }
                        }else{
                            controllers.forceStop=1
                        }
                    // }
                }

                //! [capsuleshape]
                collisionShapes: CapsuleShape {
                    id: capsuleShape
                    diameter: 50
                    height: controllers.crouchActive ? 75 : 100
                    Behavior on height {
                        NumberAnimation { duration: 100 }
                    }
                }
                property real characterHeight: capsuleShape.height + capsuleShape.diameter
                //! [capsuleshape]

                //! [triggerreports]
                sendTriggerReports: true
                //! [triggerreports]

                //! [movement]
                movement: Qt.vector3d(controllers.sideSpeed , controllers.jumpSpeed, controllers.forwardSpeed)


                // enableShapeHitCallback:true

                // onShapeHit:(body, position,  impulse, normal) =>{
                //     // console.log('will collide !')
                //     console.log(body)
                //     console.log(impulse)
                // }


                // Behavior on movement {
                //     PropertyAnimation {
                //         duration: 200
                //     }
                // }
                // onCollisionsChanged: {
                //     if(collisions===CharacterController.None){
                //         controllers.jump=false
                //     }
                // }

                //! [movement]

                //! [gravity]
                gravity: Qt.vector3d(0,-1000,0)
                //! [gravity]

                //! [camera]
                // eulerRotation.y: camera.eulerRotation.x
                PerspectiveCamera {
                    id: camera
                    position: Qt.vector3d(0, character.characterHeight , 0)

                        Model {
                            id:playerHand
                            // visible:false
                            // source: "models/player_hand.me"sh"  // Your hand model
                            source:"#Cube"
                            position: Qt.vector3d(83.4194, -100, -220.224)
                            property bool holdblock
                            scale: holdblock ? Qt.vector3d(0.5,0.5,0.5):Qt.vector3d(0.2*3, 0.1*4, 0.4*4)  // Adjust scale as needed
                            materials:holdblock?holdingBlockMaterial:handMaterial


                            PrincipledMaterial {
                                id:handMaterial
                                baseColor: "peachpuff"  // Basic skin color
                            }


                           CustomMaterial {
                                id:holdingBlockMaterial

                                fragmentShader: "images/block.frag"

                                // // Enable lighting calculations
                                // shadingMode: CustomMaterial.Shaded


                                property real progress: 0
                                property TextureInput baseTexture: TextureInput{
                                    texture:Texture {
                                        source: "images/mc.jpg"
                                        magFilter: Texture.Nearest

                                    }

                                }

                                property TextureInput crackTexture: TextureInput{
                                    enabled:false
                                }
                            }


                            // property bool mine:false

                            // modify the pivot point to apply a more realistic rotaion animation
                            ParallelAnimation{
                                id:minningAnimation
                                // running:playerHand.mine
                                // alwaysRunToEnd : true
                                loops:Animation.Infinite
                                PropertyAnimation {
                                    // id: swingAnimation
                                    target: playerHand
                                    property: "eulerRotation.x"
                                    from: 0
                                    to: 45
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                    // loops:Animation.Infinite
                                    // running:true
                                }
                                PropertyAnimation {
                                    // id: swingAnimations
                                    target: playerHand
                                    property: "eulerRotation.y"
                                    from: 0
                                    to: 45
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                    // loops:Animation.Infinite
                                    // running:true
                                }
                            }


                            SequentialAnimation{
                                running:controllers.pressed
                                alwaysRunToEnd: true
                                PropertyAnimation {
                                    // id: swingAnimation

                                    target: playerHand
                                    property: "eulerRotation.x"
                                    from: 0
                                    to: -45
                                    duration: 150
                                    easing.type: Easing.OutExpo
                                    // loops:Animation.Infinite
                                    // running:true
                                }
                                PropertyAnimation {
                                    // id: swingAnimation

                                    target: playerHand
                                    property: "eulerRotation.x"
                                    // from: 0
                                    to: 0
                                    duration: 150
                                    easing.type: Easing.OutExpo
                                    // loops:Animation.Infinite
                                    // running:true
                                }


                            }



                                SequentialAnimation{
                                    // loops:Animation.Infinite
                                    id:walkingAnimation
                                    // running:playerHand.mine
                                    // alwaysRunToEnd : true
                                    running:!controllers.crouchActive
                                    loops:Animation.Infinite
                                    // PropertyAnimation {
                                    alwaysRunToEnd: true
                                    PropertyAnimation {
                                        // id: swingAnimations
                                        target: playerHand
                                        property: "position.y"
                                        from: -100
                                        to: -115
                                        duration: controllers.sprintActive ? 350:Math.sqrt(Math.pow(character.movement.x,2)+Math.pow(character.movement.z,2)) >=5 ?600:1000
                                        easing.type: Easing.InOutQuad
                                        // loops:Animation.Infinite
                                        // running:true
                                    }
                                    PropertyAnimation {
                                        // id: swingAnimations
                                        target: playerHand
                                        property: "position.y"
                                        // from: -100
                                        to: -100
                                        duration: controllers.sprintActive ? 350:Math.sqrt(Math.pow(character.movement.x,2)+Math.pow(character.movement.z,2)) >=5 ?600:1000
                                        easing.type: Easing.InOutQuad
                                        // loops:Animation.Infinite
                                        // running:true
                                    }
                                }



                        }

                        // Model {
                        //     id:holdingBlock
                        //     source: "#Cube"
                        //     scale: Qt.vector3d(0.5,0.5,0.5)
                        //     position: Qt.vector3d(83.4194, -100, -220.224)


                        //     materials:CustomMaterial {
                        //         id:customMaterial

                        //         fragmentShader: "images/block.frag"

                        //         // // Enable lighting calculations
                        //         // shadingMode: CustomMaterial.Shaded


                        //         property real progress: 0
                        //         property TextureInput baseTexture: TextureInput{
                        //             texture:Texture {
                        //                 source: "images/mc.jpg"
                        //                 magFilter: Texture.Nearest

                        //             }

                        //         }

                        //         property TextureInput crackTexture: TextureInput{
                        //             enabled:false
                        //         }
                        //     }

                        //     SequentialAnimation{
                        //         running:controllers.pressed
                        //         alwaysRunToEnd: true
                        //         PropertyAnimation {
                        //             // id: swingAnimation

                        //             target: holdingBlock
                        //             property: "eulerRotation.x"
                        //             from: 0
                        //             to: -45
                        //             duration: 150
                        //             easing.type: Easing.OutExpo
                        //             // loops:Animation.Infinite
                        //             // running:true
                        //         }
                        //         PropertyAnimation {
                        //             // id: swingAnimation

                        //             target: holdingBlock
                        //             property: "eulerRotation.x"
                        //             // from: 0
                        //             to: 0
                        //             duration: 150
                        //             easing.type: Easing.OutExpo
                        //             // loops:Animation.Infinite
                        //             // running:true
                        //         }


                        //     }



                        //         SequentialAnimation{
                        //             // loops:Animation.Infinite
                        //             id:walkingAnimation
                        //             // running:playerHand.mine
                        //             // alwaysRunToEnd : true
                        //             running:Math.sqrt(Math.pow(character.movement.x,2)+Math.pow(character.movement.z,2)) >=5 && !controllers.crouchActive
                        //             loops:Animation.Infinite
                        //             // PropertyAnimation {
                        //             alwaysRunToEnd: true
                        //             PropertyAnimation {
                        //                 // id: swingAnimations
                        //                 target: holdingBlock
                        //                 property: "position.y"
                        //                 from: -100
                        //                 to: -115
                        //                 duration: controllers.sprintActive ? 350:600
                        //                 easing.type: Easing.InOutQuad
                        //                 // loops:Animation.Infinite
                        //                 // running:true
                        //             }
                        //             PropertyAnimation {
                        //                 // id: swingAnimations
                        //                 target: holdingBlock
                        //                 property: "position.y"
                        //                 // from: -100
                        //                 to: -100
                        //                 duration: controllers.sprintActive ? 350:600
                        //                 easing.type: Easing.InOutQuad
                        //                 // loops:Animation.Infinite
                        //                 // running:true
                        //             }
                        //         }



                        // }




                }

                //! [camera]
            }
            // OrbitCameraController {
            //     anchors.fill: parent
            //     origin: originNode
            //     camera: camera
            // }
            // WasdController {
            //      controlledObject: camera
            //      speed: 2
            //      mouseEnabled: false
            //  }
            AxisHelper {
                }
            // PointLight {
            //     position: Qt.vector3d(0, 400, 0)
            //     brightness: 200
            // }

            MouseArea {
                id:controllers
                anchors.fill: parent
                acceptedButtons:Qt.AllButtons

                property bool enableControl:false
                focus:enableControl

                property real walkingSpeed: 431
                property real speedFactor: sprintActive ? 1.45 : crouchActive ? 0.1 : 1
                property real sideSpeed: (moveLeft ? -1 : moveRight ? 1 : 0) * walkingSpeed * speedFactor*forceStop
                property real forwardSpeed: (moveForwards ? -1 : moveBackwards ? 1 : 0) * walkingSpeed * speedFactor*forceStop


                property real jumpSpeed:0


                property double forceStop:1



                Behavior on forwardSpeed {

                    NumberAnimation {
                        easing.type: Easing.OutBack
                        duration:400
                    }
                }
                Behavior on jumpSpeed {

                    NumberAnimation {
                        easing.type: Easing.OutBack
                        // duration:400
                    }
                }

                Timer{
                    id:jumpCoolDown
                    // running:true
                    property int timestep :1
                    interval:16
                    // repeat: true
                    onTriggered: {

                        // if(timestep >=14)
                        if(timestep >=20){
                            controllers.jumpSpeed=0
                            timestep=1
                            return
                        }
                        // console.log(interval * timestep)



                        timestep++
                        jumpCoolDown.start()
                    }
                }

                property bool moveForwards: false
                property bool moveBackwards: false
                property bool moveLeft: false
                property bool moveRight: false
                property bool moveUp: false
                property bool moveDown: false
                property bool jump:false

                property bool sprintActive: false
                property bool crouchActive: false

                hoverEnabled: enableControl
                cursorShape: enableControl ? Qt.BlankCursor:Qt.ArrowCursor



                Keys.onPressed: (event) => { if (controllers.enableControl) handleKeyPress(event) }
                Keys.onReleased: (event) => { if (controllers.enableControl) handleKeyRelease(event) }


                function forwardPressed() {
                    moveForwards = true
                    moveBackwards = false
                }

                function forwardReleased() {
                    moveForwards = false
                }

                function backPressed() {
                    moveBackwards = true
                    moveForwards = false
                }

                function backReleased() {
                    moveBackwards = false
                }

                function rightPressed() {
                    moveRight = true
                    moveLeft = false
                }

                function rightReleased() {
                    moveRight = false
                }

                function leftPressed() {
                    moveLeft = true
                    moveRight = false
                }

                function leftReleased() {
                    moveLeft = false
                }

                function upPressed() {
                    moveUp = true
                    moveDown = false
                }

                function upReleased() {
                    moveUp = false
                }

                function downPressed() {
                    moveDown = true
                    moveUp = false
                }

                function downReleased() {
                    moveDown = false
                }

                function sprintPressed() {
                    sprintActive = true
                    crouchActive = false
                }

                function sprintReleased() {
                    sprintActive = false
                }

                function sneakPressed() {
                    crouchActive = true
                    sprintActive = false
                }

                function sneakReleased() {
                    crouchActive = false
                }

                function handleKeyPress(event) {
                    switch (event.key) {
                    case Qt.Key_W:
                    case Qt.Key_Up:
                        forwardPressed()
                        break
                    case Qt.Key_S:
                    case Qt.Key_Down:
                        backPressed()
                        break
                    case Qt.Key_A:
                    case Qt.Key_Left:
                        leftPressed()
                        break
                    case Qt.Key_D:
                    case Qt.Key_Right:
                        rightPressed()
                        break
                    case Qt.Key_R:
                    case Qt.Key_PageUp:
                        upPressed()
                        break
                    case Qt.Key_F:
                    case Qt.Key_PageDown:
                        downPressed()
                        break
                    case Qt.Key_Shift:
                        sprintPressed()
                        break
                    case Qt.Key_Control:
                        sneakPressed()
                        break
                    case Qt.Key_Escape:
                        enableControl=false
                        break
                    case Qt.Key_Space:
                        // jump=true
                        if(character.collisions ===CharacterController.None){
                            break
                        }

                        jumpSpeed=300
                        jumpCoolDown.start()
                        break
                    }
                }

                function handleKeyRelease(event) {
                    switch (event.key) {
                    case Qt.Key_W:
                    case Qt.Key_Up:
                        forwardReleased()
                        break
                    case Qt.Key_S:
                    case Qt.Key_Down:
                        backReleased()
                        break
                    case Qt.Key_A:
                    case Qt.Key_Left:
                        leftReleased()
                        break
                    case Qt.Key_D:
                    case Qt.Key_Right:
                        rightReleased()
                        break
                    case Qt.Key_R:
                    case Qt.Key_PageUp:
                        upReleased()
                        break
                    case Qt.Key_F:
                    case Qt.Key_PageDown:
                        downReleased()
                        break
                    case Qt.Key_Shift:
                        sprintReleased()
                        break
                    case Qt.Key_Control:
                        sneakReleased()
                        break
                    case Qt.Key_Space:
                        jump=false
                        break
                    }
                }

                onPositionChanged: (mouse)=>{

                   var mouseDeltaX = mouseX - width / 2
                   var mouseDeltaY = mouseY - height / 2

                   character.eulerRotation.y -= mouseDeltaX * 0.1
                   camera.eulerRotation.x -= mouseDeltaY * 0.1

                   // Clamp vertical rotation to prevent character flipping
                   camera.eulerRotation.x = Math.max(-90, Math.min(90, camera.eulerRotation.x))

                    // playerHand.rotate(camera.eulerRotation.x,Qt.vector3d(0,1,0))

                                       // console.log(character.eulerRotation.y)

                   // Reset mouse position to center
                   window1.setCursorPos(Qt.point(rootWindow.x+ rootWindow.width/2,rootWindow.y + rootWindow.height/2));


                    if(containsPress){


                       var result = view.pick(mouseX, mouseY)

                       if (!result.objectHit || result.objectHit!==currentPressedBlock) {

                            if(!currentPressedBlock){
                                                   return
                                               }

                           currentPressedBlock.stopBreaking()
                            currentPressedBlock=undefined;
                           return
                       }
                        if(result.objectHit===currentPressedBlock){
                            console.log("Iam still Pointing")
                        }

                    }
                }
                onClicked: (mouse)=>{
                    if(!enableControl){
                        enableControl=true
                        window1.setCursorPos(Qt.point(rootWindow.x+ rootWindow.width/2,rootWindow.y + rootWindow.height/2));
                        return;
                    }


                    var result = view.pick(mouseX, mouseY)

                    if (!result.objectHit) {
                        return
                    }

                    if (mouse.button === Qt.RightButton){
                        // var hitPosition = result.objectHit.position
                        // hitPosition.x+=result.normal.x*110
                        // hitPosition.y+=result.normal.y*110
                        // hitPosition.z+=result.normal.z*110
                                   // console.log(result.objectHit.position)

                        var placingPosition  =Qt.vector3d(result.objectHit.position.x+result.normal.x*100 ,result.objectHit.position.y+result.normal.y*100,result.objectHit.position.z+result.normal.z*100);
                        var characterAbsolutePosition=Qt.vector3d(Math.trunc(character.position.x/100),Math.trunc(character.position.y/100),Math.trunc(character.position.z/100)   )
                        var placingAbsolutePosition =Qt.vector3d(Math.trunc(placingPosition.x/100),Math.trunc(placingPosition.y/100),Math.trunc(placingPosition.z/100)   )
                        // console.log("my absolute postion : "+ characterAbsolutePosition)
                        // console.log("pointint position : "+Qt.vector3d(Math.trunc(placingPosition.x/100),Math.trunc(placingPosition.y/100),Math.trunc(placingPosition.z/100)   ) )

                        if(placingAbsolutePosition.x === characterAbsolutePosition.x &&((placingAbsolutePosition.y === characterAbsolutePosition.y && Math.abs((character.position.y-character.characterHeight/2)-(placingPosition.y+50)) >=25 ) || placingAbsolutePosition.y === characterAbsolutePosition.y+1|| placingAbsolutePosition.y === characterAbsolutePosition.y+2   )&&placingAbsolutePosition.z === characterAbsolutePosition.z ){

                           console.log("you cannot place here")
                           return
                        }


                         console.log("placing ..." +  placingPosition)

                        view.placeBlock(placingPosition)
                    }else if(mouse.button === Qt.LeftButton){
                                   // console.log(result.objectHit.position)

                        // result.objectHit.startBreaking()
                        // result.objectHit.destroy()
                            // result.objectHit.startBreaking()
                    }
                }
                property var currentPressedBlock:undefined
                onPressed: (mouse)=>{
                               console.log('Pressed')
                    var result = view.pick(mouseX, mouseY)

                    if (!result.objectHit) {
                        return
                    }

                     if(mouse.button === Qt.LeftButton){
                                   // console.log(result.objectHit.position)

                        // result.objectHit.startBreaking()
                        // result.objectHit.destroy()
                            currentPressedBlock=result.objectHit;
                            result.objectHit.startBreaking()
                    }
                }
                onReleased: (mouse)=>{
                    // var result = view.pick(mouseX, mouseY)

                    // if (!result.objectHit) {
                    //     return
                    // }
                    if(currentPressedBlock===null || currentPressedBlock===undefined){
                                    return
                                }

                     if(mouse.button === Qt.LeftButton){
                                   // console.log(result.objectHit.position)

                        // result.objectHit.startBreaking()
                        // result.objectHit.destroy()
                        currentPressedBlock.stopBreaking()
                        currentPressedBlock=undefined;
                    }
                }
            }
            function placeBlock(position) {
                var block = blockComponent.createObject(view.scene, {
                    "position": position
                })
            }

            Component.onCompleted: {
                // Create initial terrain
                for (var x = -10; x <= 10; x++) {
                    for (var z = -10; z <= 10; z++) {
                        view.placeBlock(Qt.vector3d(x*100 -50, -50, z*100-50))
                    }
                }
            }

        }



    // Crosshair
    Rectangle {
        anchors.centerIn: parent
        width: 2
        height: 20
        color: "white"
    }
    Rectangle {
        anchors.centerIn: parent
        width: 20
        height: 2
        color: "white"
    }

}
