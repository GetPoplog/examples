compilehere
	robolex.p
	robogram.p
	;

/*
;;; TESTS

typenp_sing([thing in front of the car]) ==>
typenp_pl([things in front of the car]) ==>
typenp_pl([things in front of the cars on the table]) ==>
typenp_sing([blue thing in front of the red car]) ==>
typenp_sing([thing which is in the red box]) ==>
typenp_sing([blue thing in front of the car which is in the red box]) ==>
typenp_sing([car in the red box]) ==>
rel_descr([in the red box on the table]) ==>
typenp_sing([car in the red box on the table]) ==>

rel_descr([in the red box]) ==>
rel_descr([which is in the red box]) ==>
rel_descr([that is in the red box]) ==>
typenp_sing([car]) ==>
typenp_sing([red car]) ==>
typenp_sing([red car that is on the table]) ==>
typenp_pl([cars in the red box]) ==>
rel_descr_pl([that are in the red box]) ==>
typenp_sing([car that is in the red box]) ==>
typenp_pl([cars that are in the red box]) ==>
typenp_pl([big blue cars that are in the red box]) ==>

S([the car is red]) ==>
S([the car was red]) ==>

S([put the red thing in front of the car]) ==>
S([put the red thing near Nick]) ==>
S([put the red thing to the left of Nick]) ==>
S([move the red thing to the left of the blue thing]) ==>
S([move the red thing in front of the blue thing]) ==>
S([move the red thing to  the blue thing]) ==>
S([move the red thing to the front of the blue thing]) ==>
to_pp([to in front of the blue thing]) ==>
;;; this should work but doesn't
S([move the red thing to in front of the blue thing]) ==>

;;; get a list of all the failed parse attempts in the previous
;;; example
;;; how long is the list
no_parse_found.datalist.length ==>
;;; print it out
no_parse_found.datalist ==>

S([move the red thing from the left of the blue thing]) ==>
S([move the red thing from the front of the blue thing]) ==>
;;; should this work?
S([move the red thing from in front of the blue thing]) ==>
dest_pp([to the left of the blue thing]) ==>
dest_pp([in front of the blue thing]) ==>
to_pp([to the left of the blue thing]) ==>
to_pp([to the left of Nick]) ==>

S([put the red thing to the left of the table]) ==>

S([put the square near the red car]) ==>

S([what is near the red ball])==>
;;; should this work?
S([what is to the left of the red ball])==>
S([what is on the left of the red ball])==>
S([what is behind the red ball])==>
S([what is in front of the red ball])==>
S([what is under the table])==>

S([what is not under the table])==>

S([is the red square on the triangle])==>

S([is the red square blue])==>

S([is the red square on the triangle])==>
S([put the red square on the table])==>
S([is the red square in front of the table])==>
S([is the red square blue and big])==>

S([is the red square to the left of the circle])==>
S([is the red square not to the left of the circle])==>
S([put the red square under the table])==>
S([put the red square to the left of the table])==>
S([is the red square to the left of the box on the table])==>
S([is the square square to the left of the table])==>
S([put the big cow in front of the red ball])==>
S([is the big cow in front of the red ball])==>
complement([in front of the red ball])==>
S([is the big cow red])==>
S([what was in front of the big red cow])==>
S([what was not in front of the big red cow])==>
S([what was in front of the big red cow])==>
S([put the big cow at the front of the red ball])==>

S([is the red thing square]) ==>
S([is the red thing a square]) ==>

S([get the ball and put it here]) ==>
S([get the ball or fetch the red cow]) ==>
S([get the ball]) ==>
S([get it]) ==>
S([put the ball in the box]) ==>
S([put the ball here]) ==>
S([put it in front of the ball]) ==>
S([what is in front of the ball]) ==>
S([is the car in front of the ball]) ==>

S([look at the red ball]) ==>
S([touch the red ball]) ==>
S([is Nick"s red car big]) ==>
S([is Nick"s red car big and heavy]) ==>
S([is Aaron"s red car big and heavy and blue]) ==>
complement([big and blue and heavy]) ==>
S([is the red car big and heavy]) ==>
S([Nick"s red car is big and heavy]) ==>
S([Nick"s red car is big]) ==>
S([pick up Nick"s red car]) ==>
S([will Nick look at the red ball]) ==>
S([can Nick look at the red ball]) ==>
S([can Nick look at the red ball and pick it up]) ==>
S([look at the red ball and touch it]) ==>
S([look at the red ball and pick it up]) ==>
S([look at the red ball or touch it]) ==>
S([touch the car near the table]) ==>

S([look at the red ball and pick it up from under the box]) ==>
S([look at the red ball and fetch it from under the box]) ==>

;;; fails
S([look at the red ball and grab it from under the box]) ==>
;;; succeeds
S([look at the red ball and move it from under the box]) ==>
S([look at the red ball and put it next to the box]) ==>
S([look at the red ball and put it close to the box]) ==>

S([take the ball])==>
S([take the ball to the kitchen])==>
S([take the ball to the blue triangle])==>
S([take the ball to the kitchen and put the box in the bedroom])==>
S([put the box in the bedroom and stop])==>
S([stop]) ==>

S([after the ball is in the kitchen  put the box in the bedroom])==>
S([he is red ])==>
S([the book is red ])==>

S([Nick"s car is red ]) ==>
S([get Nick"s car]) ==>
S([take the ball to my car]) ==>
S([give Nick the car]) ==>
S([will he give Nick the car]) ==>
S([he pushes the car]) ==>
S([he gives Nick the car]) ==>
S([they give Nick the car]) ==>
S([send her the car]) ==>
S([send her the car]) ==>
S([give Aaron"s car to her]) ==>
S([give Aaron"s car to her]) ==>
S([give her Aaron"s car]) ==>
S([Aaron"s car is on the table]) ==>
np_subj([Aaron"s car])==>
complement([on the table]) ==>
S([the red car"s bonnet is black]) ==>
S([the car"s bonnet is on the cow]) ==>
S([the red car"s bonnet is on the cow]) ==>

np_subj([the red car"s bonnet]) ==>

question([where is the red car"s bonnet]) ==>
assertion([where is the red car"s bonnet]) ==>
S([where is the red car"s bonnet]) ==>
np_subj([where is the red car"s bonnet]) ==>
np_subj([where is the red car"s])==>

S([where is the other bonnet]) ==>
question([where is the other bonnet]) ==>

S([which car is red]) ==>
np_subj([Nick])==>
person_name([Nick])==>
person_pos([her])==>

S([Aaron did go to the car]) ==>
S([Aaron did not go to the car]) ==>
S([Aaron pushes the car]) ==>
S([Aaron did push the car]) ==>
S([Aaron did not push the car]) ==>
S([Aaron does not push the car]) ==>
S([Aaron pushes the car onto the table]) ==>
S([Aaron did push the car onto the table]) ==>
S([Aaron did not push the car onto the table]) ==>
S([Aaron does not push the car onto the table]) ==>
S([Aaron does not push the car onto the table from in front of the box]) ==>
S([did Aaron push the car onto the table from in front of the box]) ==>
possessive([Nick"s])==>
possessive([the red car"s])==>
possessive([the big red car"s])==>
possessive([the big red car on the table"s])==>
typenp_sing([car on the table])==>
typenp_sing([big red car on the table])==>
typenp_sing([big red car on the table"s bonnet])==>
pos_np_sing([the big red car on the table"s bonnet])==>
pos_np_sing([Nick"s car])==>
possessive([my])==>
possessive([the red car"s])==>
pos_np_sing([the red car"s bonnet])==>

S([how big is the table])==>
S([bigger than the red box])==>
S([bigger than Nick"s car])==>

S([where are Jeremy and Aaron])==>
S([where are the doors])==>
S([where are the car"s doors])==>
S([where is the car])==>
S([where is the car"s door])==>
np_obj([the car"s doors])==>
complement([the car"s doors])==>
complement([the car"s door])==>
np_subj_pl([the car"s doors])==>
np_subj([his car])==>
"the block"s owner" "the car"s big box"

complement([red])==>
complement([bigger than Nick"s car])==>
complement([not bigger than Nick"s car])==>
complement([red or green])==>
complement([a car])==>
complement([a car and a square])==>
complement([a car or not red])==>
complement([red or bigger than Nick"s car])==>
complement([red or not bigger than Nick"s car])==>
setup(robogram, robolex);
robolex ==>


;;; this generates a random sentence then pauses, then if you
;;; press return it parses the sentence.
;;; Then press return to continue
generate_random_sentences(robogram, robolex, 35);
generate_random_sentences(robogram, robolex, 5);

no_parse_found.datalist ==>
no_parse_found.datalist.length ==>

generate_category("question", robogram, robolex)==>
gen_category("question", robogram, robolex)==>

gen_category("assertion", robogram, robolex)==>

** [Marek did not look at those blocks]
** [Marek does not shove Box2 and Ball2 in front of Dora's cube]
** [Bernhard can touch his cow]
** [this is not a square's horizontal square bathroom under that right side of
         him]
** [He can hoist you far from any bonnets]


gen_category("command", robogram, robolex)==>
** [get Box1's horizontal ball which is in front of Ball2 and Box2]

repeat 10 times
	gen_category(oneof([assertion question command]), robogram, robolex)==>
endrepeat


vars, speak_voice = 'm1', speak_amplitude = 160, speak_speed = 150;
vars, speak_voice = 'm1', speak_amplitude = 90, speak_speed = 150;
vars, speak_voice = 'm1', speak_amplitude = 9, speak_speed = 150;


repeat 10 times

	gen_speak(gen_category(oneof([assertion question command]), robogram, robolex));
;;;	gen_speak(gen_category(oneof([ command]), robogram, robolex));
;;;	gen_speak(gen_category(oneof([question]), robogram, robolex));

	syssleep(150);
endrepeat                                    	

gen_category(oneof([assertion question command]), robogram, robolex)==>

detnp_pl([some cornflakes]) ==>

command([get some cornflakes and put them here])==>
command([get some cornflakes])==>
*/
