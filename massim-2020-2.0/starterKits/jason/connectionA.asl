// Agent bob in project MAPC2018.mas2j

/* Initial beliefs and rules */

/* Initial goals */
getblock(f).
requestblock(f).
stop(f).
hasgoal(f).
!start.

/* Plans */

+step(StepID) : true <-
	if(hasgoal(f) & getblock(f)){
	!searchDispenser;
	}
	if(requestblock(f) & stop(t) & getblock(f)){
	!checkDispenser;
	!checkRequest;
	}
	if(getblock(f) &requestblock(t) & stop(t)){
	!checkAttach;
	}
	if(hasgoal(f) & getblock(t)){
	!searchTaskboard;
	}
	if(stop(t) & getblock(t)){
	!checkTaskboard;
	}
	.
+!searchTaskboard :true<-
	?thing(X, Y, Type, Details);
	-+norandomm(f);
	if(Type==taskboard){
		-+hasgoal(t);
		-+norandomm(t);
		 -+goal(Type,X,Y,Block);
	}.	
	
+!checkTaskboard:true<-
	?thing(X, Y, Type, Details);
	if(Type==taskboard ){
		if(X>1 | X<=-2| Y>1 | Y<=-2){
		-+stop(f);
		-+hasgoal(f);}
	}.	
	
+!searchDispenser:true<-
	?thing(X, Y, Type, Details);
	-+norandomm(f);
	if(Type==dispenser){
		-+hasgoal(t);
		-+norandomm(t);
		 -+goal(Type,X,Y-1,Details);
	}.		
				
+!checkDispenser:true<-
	?thing(X, Y, Type, Details);
	if(Type==dispenser & not(X==0 & Y==1)){
		-+stop(f);
		-+hasgoal(f);
		-+requestblock(f);
	}.	
	
+!checkAttach:true<-
	?lastActionResult(Result);
	?lastAction(Type);
	if(Result==success & Type ==attach){
		-+getblock(t);
		-+stop(f);
		-+hasgoal(f);
		-+requestblock(f);
	}
	if(Result==failed_target & Type ==attach){
		-+stop(f);
		-+hasgoal(f);
		-+requestblock(f);
	}.	
	
+!checkRequest:true<-
	!checkDispenser;
	?lastActionResult(Result);
	?lastAction(Type);
	if(not Result==failed_target & Type ==request){
	-+requestblock(t);
	}
	?thing(X, Y, Type, Details);
	if(Type==dispenser & X==0 & Y==1){
		-+requestblock(f);
	}.
	
+actionID(ActionID):true <- 
		if(stop(f) & getblock(f)){
		!move;}
		if(getblock(f) & requestblock(f)& stop(t)){
		request(s);!checkRequest;}
		if(getblock(f) &requestblock(t) & stop(t)){
		attach(s);!checkAttach;}
		if(getblock(t) & stop(f)){
		!move;!checkTaskboard;}
		skip;!checkTaskboard.
		
		
+!move:true <-
	if(hasgoal(t)){
		!goalmove;
	}
	if(not norandomm(t)){
		!randommove;
	}
	skip.
	
+!goalmove: true<-
	?goal(Type,X,Y,Block);
	if(getblock(f)){
	if(X>0){
		move(e);
	}
	if(X<0){
		move(w);
	}
	if(Y<0){
		move(n);
	}	
	if(Y>0){
		move(s);
	}
	 if(X==0 & Y==0){
		-+stop(t);
	}
	}
	if(getblock(t)){
	if(X>1){
		move(e);
	}
	if(X<=-2){
		move(w);
	}
	if(Y<=-2){
		move(n);
	}	
	if(Y>1){
		move(s);
	}
	 if(X<=1 & X>=-1& Y<=1 & Y>=-1 & getblock(t)){
		-+stop(t);
	}
	}
	-+hasgoal(f).
	
		
+!randommove: .random(Number)<-
	if(Number <= 0.25){
		if(not randomDirection(s)){
		move(n);
		-+randomDirection(n);}
		if(randomDirection(s)){
		move(s);
		-+randomDirection(s);
		}
	}
	if(Number<=0.50& Number > 0.25){
		if(not randomDirection(n)){
		move(s);
		-+randomDirection(s);}
		if(randomDirection(n)){
		move(n);
		-+randomDirection(n);
		}
	}
	if(Number<=0.75& Number > 0.5 ){
	if(not randomDirection(e)){
		move(w);
		-+randomDirection(w);}
		if(randomDirection(e)){
		move(e);
		-+randomDirection(e);
		}
	}
	if( Number <=1& Number > 0.75 ){
		if(not randomDirection(w)){
		move(e);
		-+randomDirection(e);}
		if(randomDirection(w)){
		move(w);
		-+randomDirection(w);
		}
	}.

	
