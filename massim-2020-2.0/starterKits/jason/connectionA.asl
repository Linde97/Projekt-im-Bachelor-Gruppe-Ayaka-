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
	if(hasgoal(f)){
	!searchDispenser;}
	if(stop(t)){
	!checkDispenser;
	}
	if(requestblock(f) & stop(t)){
	!checkRequest;
	}
	if(getblock(f) &requestblock(t) & stop(t)){
	!checkAttach;
	}.

+!searchDispenser:true<-
	?thing(A, B, Type, Details);
	X=A[percept];Y=B[percept];
	-+norandomm(f);
	if(Type==dispenser){
		if(hasgoal(f)){
		-+hasgoal(t);
		-+mygoal(Details[percept]);
		}
		-+norandomm(t);
		 -+goal(X,Y-1);
	}.		
				
+!checkDispenser:true<-
	?thing(A, B, Type, Details);
	X=A[percept];Y=B[percept];
	if(Type==dispenser & not(X==0 & Y==1)){
		-+stop(f);
		-+hasgoal(f);
	}.	
+!checkAttach:true<-
	?lastActionResult(result);
	if(not result==failed_target){
		-+getblock(t);
	}.	
	
+!checkRequest:true<-
	-+requestblock(t);
	?lastActionResult(result);
	if(result==failed_target){
	-+requestblock(f);
	}.
	
+actionID(ActionID):true <- 
		if(stop(f) & getblock(f)){
		!move;}
		if(getblock(f) & requestblock(f)& stop(t)){
		request(s);}
		if(getblock(f) &requestblock(t) & stop(t)){
		!getBlock;}
		if(getblock(t)){
		skip;}.
		
		
+!move:true <-
	if(hasgoal(t)){
		!goalmove;
	}
	if(not norandomm(t)){
		!randommove;
	}.
	
+!goalmove: true<-
	?goal(X,Y);
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
	-goal(X,Y);
	-+hasgoal(f).
	
		
+!randommove: .random(Number)<-
	if(Number <= 0.25){
		move(n);
	}
	if(Number<=0.50){
		move(s);
	}
	if(Number<=0.75){
		move(w);
	}
	if( Number <=1){
		move(e);
	}.

+!getBlock:true<-
		attach(s);
		-+getblock(t);
		-+stop(f);
		-+hasgoal(f);
		-+requestblock(f).
