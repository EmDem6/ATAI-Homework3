debug(3).

// Name of the manager
manager("Manager").

// Team of troop.
team("ALLIED").
// Type of troop.
type("CLASS_SOLDIER").





{ include("jgomas.asl") }




// Plans


/*******************************
*
* Actions definitions
*
*******************************/

/////////////////////////////////
//  GET AGENT TO AIM 
/////////////////////////////////  
/**
* Calculates if there is an enemy at sight.
* 
* This plan scans the list <tt> m_FOVObjects</tt> (objects in the Field
* Of View of the agent) looking for an enemy. If an enemy agent is found, a
* value of aimed("true") is returned. Note that there is no criterion (proximity, etc.) for the
* enemy found. Otherwise, the return value is aimed("false")
* 
* <em> It's very useful to overload this plan. </em>
* 
*/  
+!get_agent_to_aim
<-  ?debug(Mode); if (Mode<=2) { .println("Looking for agents to aim."); }
?fovObjects(FOVObjects);
.length(FOVObjects, Length);

?debug(Mode); if (Mode<=1) { .println("El numero de objetos es:", Length); }

if (Length > 0) {
    +bucle(0);
    
    -+aimed("false");
    
    while (aimed("false") & bucle(X) & (X < Length)) {
        
        //.println("En el bucle, y X vale:", X);
        
        .nth(X, FOVObjects, Object);
        // Object structure
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        .nth(2, Object, Type);
        
        ?debug(Mode); if (Mode<=2) { .println("Objeto Analizado: ", Object); }
        
        if (Type > 1000) {
            ?debug(Mode); if (Mode<=2) { .println("I found some object."); }
        } else {
            // Object may be an enemy
            .nth(1, Object, Team);
            ?my_formattedTeam(MyTeam);
            
            if (Team == 200) {  // Only if I'm ALLIED

                //.println("HEMOS VISTO UN ENEMIGO uuh que miedo ");

                ?debug(Mode); if (Mode<=2) { .println("Aiming an enemy. . .", MyTeam, " ", .number(MyTeam) , " ", Team, " ", .number(Team)); }
                
                //+aimed_agent(Object);
                //-+aimed("true");
                /*.nth(6, Object, pos(XX,_,ZZ));

                .println("X: ", XX , "  ",ZZ);

                ?my_position(MX,MY,MZ);
                
                .println("X: ", XX , "  ",ZZ);
                
                X1 = (MX + 1);
                X2 = (MX - 1);

                Z1 = (MZ + 1);
                Z2 = (MZ - 1);

                .println("X: ", XX , "  ",ZZ);

                !distance( pos( MX, MY, Z1 ), pos( XX, MY, ZZ ) );
                ?distance(D1);

                !distance( pos( X1, MY, MZ ), pos( XX, MY, ZZ ) );
                ?distance(D2);

                !distance( pos( MX, MY, Z2 ), pos( XX, MY, ZZ ) );
                ?distance(D3);

                !distance( pos( X2, MY, MZ ), pos( XX, MY, ZZ ) );
                ?distance(D4);

                .println("X: ", XX , "  ",ZZ);

                .println("X: ", MX , "  ",MZ);

                .println("X1: ", X1 , "  ",X2);
                .println("Z1: ", Z1 , "  ",Z2);

                .println("D1: ", D1 , "  ",D2 , D3,D4);

                Max = D1;
                .println("Max: ", Max);
                
                if (D2 > Max) {
                
                    .println("Max2: ", Max);
                    Max = D2;

                }

                if (D3 > Max) {
                
                    Max = D3;
                }

                if (D4 > Max) {
                
                    Max = D4;
                }
                
                .println("Max: ", Max);
                if (Max == D1) {
                
                    NewX = MX;
                    NewZ = Z1;
                }

                if (Max == D2) {
                
                    NewX = X1;
                    NewZ = MZ;
                }
                
                if (Max == D3) {
                
                    NewX = MX;
                    NewZ = Z2;
                }

                if (Max == D1) {
                
                    NewX = X2;
                    NewZ = MZ;
                }
                .println("Max: ", Max);
                /*
                .println("X: ", XX);
                
                VectorX = -(XX - MX);
                VectorZ = -(ZZ - MZ);
                .println("X: ", XX);

                
                //VectorX = VectorX / (math.sqrt(VectorX * VectorX + VectorZ * VectorZ));
                //VectorZ = VectorZ / (math.sqrt(VectorX * VectorX + VectorZ * VectorZ));
                .println("X: ", XX);
                NewX = VectorX * 2 + MX;
                NewZ = VectorZ * 2 + MZ;
                .println("X: ", XX);
                .println("Estoy en la posicion " , MX , "  " , MZ , " Y me muevo a la posicion " , NewX, "  " , NewZ);
                .println("X: ", XX);
                */
                .nth(6, Object, pos(XX,_,ZZ));
                
                ?my_position(MIX,MIY,MIZ);
                
                VectorX = MIX - XX;
                VectorZ = MIZ - ZZ;

                //.println("VectorX =", VectorX, ", VectorZ = ", VectorZ, "Bien Bien");
                //ModuloS = VectorX * VectorX + VectorZ * VectorZ;
                //.println("Hemos calculado el modulo bro");
                //VectorX = VectorX / (math.sqrt(ModuloS));
                // .println("HOLIIII BRO, CALCULANDO VECTOR X");
                //VectorZ = VectorZ / (math.sqrt(VectorX * VectorX + VectorZ * VectorZ));


                !distance(pos(VectorX,0,VectorZ), pos(0,0,0));

                ?distance(MODULO);

                VectorUX = VectorX / MODULO;
                VectorUZ = VectorZ / MODULO;

                +newPos(0,0);
                +position(invalid);
                +contador(5);
                while (position(invalid)) {
                    -position(invalid);
                    ?contador(Mult);
                    NewX = VectorUX * Mult + MIX;
                    NewZ = VectorUZ * Mult + MIZ;

                    

                    check_position(pos(NewX, 0, NewZ));


                    if (NewX > 255 | NewX < 0 | NewZ > 255 | NewZ < 0) {
                        +newPos2(0,0);
                        while (position(invalid)) {
                            -position(invalid);
                            .random(X);
                            .random(Z);
                            NewObjectiveX = X * 255;
                            NewObjectiveZ = Z * 255;
                            check_position(pos(NewObjectiveX, 0, NewObjectiveZ));
                            -+newPos(NewObjectiveX, NewObjectiveZ);
                        }
                        ?newPos(NewX,NewZ);
                    }

                    -+newPos(NewX, NewZ);
                    -+contador(Mult + 1);
                }
                ?newPos(NewX,NewZ);

                

                //.println("Estoy en la posicion " , MIX , "  " , MIZ , " Y me muevo a la posicion " , NewX, "  " , NewZ);

                .my_name(MyName);
                ?current_task(task(C_priority, _, _, _, _));
                !add_task(task("TASK_GOTO_POSITION", MyName, pos(NewX, 0, NewZ), ""));
                -+state(standing);
                -goto(_,_,_)
                
            }
            
        }
        
        -+bucle(X+1);
        
    }
    
    
}

-bucle(_).

/////////////////////////////////
//  LOOK RESPONSE
/////////////////////////////////
+look_response(FOVObjects)[source(M)]
    <-  //-waiting_look_response;
        .length(FOVObjects, Length);
        if (Length > 0) {
            ?debug(Mode); if (Mode<=1) { .println("HAY ", Length, " OBJETOS A MI ALREDEDOR:\n", FOVObjects); }
        };    
        -look_response(_)[source(M)];
        -+fovObjects(FOVObjects);
        //.//;
        !look.
      
        



/////////////////////////////////
//  PERFORM ACTIONS
/////////////////////////////////
/**
* Action to do when agent has an enemy at sight.
* 
* This plan is called when agent has looked and has found an enemy,
* calculating (in agreement to the enemy position) the new direction where
* is aiming.
*
*  It's very useful to overload this plan.
* 
*/
+!perform_aim_action
    <-  // Aimed agents have the following format:
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        ?aimed_agent(AimedAgent);
        ?debug(Mode); if (Mode<=1) { .println("AimedAgent ", AimedAgent); }
        .nth(1, AimedAgent, AimedAgentTeam);
        ?debug(Mode); if (Mode<=2) { .println("BAJO EL PUNTO DE MIRA TENGO A ALGUIEN DEL EQUIPO ", AimedAgentTeam);             }
        ?my_formattedTeam(MyTeam);


        if (AimedAgentTeam == 200) {
    
                .nth(6, AimedAgent, NewDestination);
                ?debug(Mode); if (Mode<=1) { .println("NUEVO DESTINO DEBERIA SER: ", NewDestination); }
          
            }
 .

/**
* Action to do when the agent is looking at.
*
* This plan is called just after Look method has ended.
* 
* <em> It's very useful to overload this plan. </em>
* 
*/
+!perform_look_action .
   /// <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_LOOK_ACTION GOES HERE.") }. 

/**
* Action to do if this agent cannot shoot.
* 
* This plan is called when the agent try to shoot, but has no ammo. The
* agent will spit enemies out. :-)
* 
* <em> It's very useful to overload this plan. </em>
* 
*/  
+!perform_no_ammo_action . 
   /// <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_NO_AMMO_ACTION GOES HERE.") }.
    
/**
     * Action to do when an agent is being shot.
     * 
     * This plan is called every time this agent receives a messager from
     * agent Manager informing it is being shot.
     * 
     * <em> It's very useful to overload this plan. </em>
     * 
     */
+!perform_injury_action .
    ///<- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_INJURY_ACTION GOES HERE.") }. 
        

/////////////////////////////////
//  SETUP PRIORITIES
/////////////////////////////////
/**  You can change initial priorities if you want to change the behaviour of each agent  **/
+!setup_priorities
    <-  +task_priority("TASK_NONE",0);
        +task_priority("TASK_GIVE_MEDICPAKS", 2000);
        +task_priority("TASK_GIVE_AMMOPAKS", 0);
        +task_priority("TASK_GIVE_BACKUP", 0);
        +task_priority("TASK_GET_OBJECTIVE",1000);
        +task_priority("TASK_ATTACK", 1000);
        +task_priority("TASK_RUN_AWAY", 1500);
        +task_priority("TASK_GOTO_POSITION", 3000);
        +task_priority("TASK_PATROLLING", 500);
        +task_priority("TASK_WALKING_PATH", 1750).   



/////////////////////////////////
//  UPDATE TARGETS
/////////////////////////////////
/**
 * Action to do when an agent is thinking about what to do.
 *
 * This plan is called at the beginning of the state "standing"
 * The user can add or eliminate targets adding or removing tasks or changing priorities
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */

+!update_targets
	<-	?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR UPDATE_TARGETS GOES HERE.") }.
	
	
	
/////////////////////////////////
//  CHECK MEDIC ACTION (ONLY MEDICS)
/////////////////////////////////
/**
 * Action to do when a medic agent is thinking about what to do if other agent needs help.
 *
 * By default always go to help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
 +!checkMedicAction
     <-  -+medicAction(on).
      // go to help
      
      
/////////////////////////////////
//  CHECK FIELDOPS ACTION (ONLY FIELDOPS)
/////////////////////////////////
/**
 * Action to do when a fieldops agent is thinking about what to do if other agent needs help.
 *
 * By default always go to help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
 +!checkAmmoAction
     <-  -+fieldopsAction(on).
      //  go to help



/////////////////////////////////
//  PERFORM_TRESHOLD_ACTION
/////////////////////////////////
/**
 * Action to do when an agent has a problem with its ammo or health.
 *
 * By default always calls for help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
+!performThresholdAction
       <-
       
       ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_TRESHOLD_ACTION GOES HERE.") }
       
       ?my_ammo_threshold(At);
       ?my_ammo(Ar);
       
       if (Ar <= At) { 
          ?my_position(X, Y, Z);
          
         .my_team("fieldops_ALLIED", E1);
         //.println("Mi equipo intendencia: ", E1 );
         .concat("cfa(",X, ", ", Y, ", ", Z, ", ", Ar, ")", Content1);
         .send_msg_with_conversation_id(E1, tell, Content1, "CFA");
       
       
       }
       
       ?my_health_threshold(Ht);
       ?my_health(Hr);
       
       if (Hr <= Ht) { 
          ?my_position(X, Y, Z);
          
         .my_team("medic_ALLIED", E2);
         //.println("Mi equipo medico: ", E2 );
         .concat("cfm(",X, ", ", Y, ", ", Z, ", ", Hr, ")", Content2);
         .send_msg_with_conversation_id(E2, tell, Content2, "CFM");

       }
       .
       
/////////////////////////////////
//  ANSWER_ACTION_CFM_OR_CFA
/////////////////////////////////

     

    
+cfm_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_agree GOES HERE.")};
      -cfm_agree.  

+cfa_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_agree GOES HERE.")};
      -cfa_agree.  

+cfm_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_refuse GOES HERE.")};
      -cfm_refuse.  

+cfa_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_refuse GOES HERE.")};
      -cfa_refuse.  



/////////////////////////////////
//  Initialize variables
/////////////////////////////////

+!init
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR init GOES HERE.")}.  



