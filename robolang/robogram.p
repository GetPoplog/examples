/* --- Copyright University of Birmingham 2010. All rights reserved. ------
 > File:            ?????/robogram.p
 > Purpose:         Grammar for a 'toy' robot language for interaction
                    and for thinking.
 > Author:          Aaron Sloman, Oct 19 2010 (see revisions)
 > Documentation:
 > Related Files:   newgrammar.p robolex.p, and test_robolang.p
 */

section;

;;; allow up to 320 Mbytes
80000000 ->popmemlim;

;;; start with 160 Mbytes
40000000 -> popminmemlim;

;;; For tracing garbage collections
;;; true -> popgctrace;

;;; First compile two programs from the pop11 library.
;;; The first provides mechanisms for taking a simple recursive context
;;; free grammar, and simple lexicon (ignoring morphology and many other
;;; details) and producing
;;;
;;;     1. a random *generator* for sentences based on the grammar and
;;;        lexicon
;;;     2. a collection of *parsers* for the non-terminals in the
;;;        grammar. Replaced by tparse below.
;;;
uses teaching

compilehere
    newgrammar.p
    robolex.p
    ;

;;; The second extends the generator to generate expressions of any
;;; category in the grammar.
uses generate_category

/*

gen_apostrophe([This is John in his car ]) =>
    ** [This is John in his car]

gen_apostrophe([This is John " s car ]) =>
** [This is John's car]

gen_apostrophe([it " s cat ate Mary " s dog]) =>
gen_apostrophe([it " s dog ate Mary " s mouse]) =>

gen_apostrophe([John " s cat ate Mary " s dog]) =>
** [John's cat ate Mary's dog]

*/

define gen_apostrophe(list)->list;

    lvars First, Left, Right, Rest;

    while list matches ! [??First ?Left " ?Right ??Rest] do

        [   ^^First
        %
        if member(Left, [it It]) and Right == "s" then
            "its"
        else
            consword( Left >< '\'' >< Right )
        endif
        %
            ^^Rest] -> list

    endwhile

enddefine;

vars procedure gen_category = (generate_category <> gen_apostrophe);

vars, speak_voice = 'm1', speak_amplitude = 30, speak_speed = 150;

define gen_speak(sentence);

    ;;; -a gives amplitude
    ;;; -a <integer>
    ;;;   Amplitude, 0 to 200, default is 100

    sentence =>
    ;;;sysflush(popdevout);
    vedrefresh();

;;; sysobey('espeak -a 10 -v+m4 -s 100 "'>< sentence ><'"');
;;; sysobey('espeak  -v+m1 -s 100 "'>< sentence ><'"');
    sysobey('espeak  -v+' >< speak_voice
            >< ' -a' >< speak_amplitude ><
            ' -s' >< speak_speed ><' "'>< sentence ><'"');

enddefine;


;;; This controls recursion depth for generating expressions
20 -> maxlevel;

;;; The grammar below defines the non-terminals, with a lot of semantics
;;; 'compiled into' the syntax, using ideas I learnt from Gerald Gazdar
;;; many years ago. This uses LIB GRAMMAR in Pop-11, but could be
;;; transferred to other systems.
;;; CoSy uses a more 'grown up' formalism for specifying a language, with
;;; much richer and more complex tools.

;;; Two lists are defined: robolex, a lexicon in the form of a list of
;;; lists, where each list starts with a word that is the name of a
;;; lexical category, followed by examples of the category, e.g.
;;;     [adj big blue square]
;;; In this toy system there is no morphology. E.g. it is possible
;;; to have
;;;     [sing_noun car tree elephant sheep]
;;;     [plur_noun cars trees elephants sheep]
;;;
;;; The grammar is a list of lists, where each list starts with a
;;; category name followed by examples of rules for that category,
;;; where the rules may be recursive, or even mutually recursive.
;;;
;;; This provides a contex-free grammar defining non-terminals
;;; in the language, in the form of a list of lists of lists, e.g.
;;;
;;; The format
;;;     [A [P Q R] [S T U] [V W]]
;;; means
;;;     An A can be
;;;         of the form P Q R, or of the form S T U, or of the form V W.
;;;
;;; Each of P, Q, R, S, T, U must be either listed in the lexicon or
;;; defined in the grammar as a non-terminal, but not both.
;;;

;;; Two global variables, robolex and robogram:
;;; sample lexicon and sample grammar.
;;; compilehere
;;;     robolex.p
;;;     ;


global vars robolex;

global vars
    ;;; The lexicon: an arbitrary sample.
    ;;; Each entry is the lexical type name and a list of instances
    ;;; The same word can be in different lexical entries
    ;;; e.g. 'left' could be verb and a spatial relation word
    ;;; (Some of the things in the grammar and lexicon are experimental and
    ;;; should be removed for serious use, e.g. names of people.)
    ;;;
    robogram =
    [

        ;;; "S" by convention is the top level category, though here it includes
        ;;; things that would not all be called sentences, e.g. a complete
        ;;; answer to a question like 'Which one did you pick up?' That could
        ;;; be a noun phrase.
        ;;;
        ;;; There are several types of 'S' (valid sentences), assertions
        ;;; questions, commands, answers, each defined below.
        [S
            [assertion]
            [question]
            [command]
            [answer]
        ]
        ;;;
        ;;; Varieties of assertion. Note the ad-hoc handling of negation.
        [assertion
            ;;; Many assertions are statements of the form X is Y
            ;;; or X is not Y
            ;;;  hack to prevent infinite recursion
            [assertion and assertion]
            [assertion or assertion]
            ;;; Predications
            [np_subj_sing is_verb complement]
            ;;;
            ;;; Identity statements and their negations
            ;;; identity statements
            [np_subj_sing is_verb np_subj_sing]
            [np_subj_sing is_verb not np_subj_sing]
            ;;;
            ;;; restricting these to 'agent' subjects may be wrong
            [agent_np_subj agent_doesvp]
            [agent_np_subj does not agent_dovp]
            ;;; this becomes past tense
            [agent_np_subj did agent_dovp]
            [agent_np_subj did not agent_dovp]
            [agent_np_subj can agent_dovp]
            [agent_np_subj cannot agent_dovp]
            [agent_np_subj will agent_dovp]
            [agent_np_subj will not agent_dovp]
            [np_subj_sing agent_doesvp]
            [nonagent_np vp]
            ]
        ;;;
        ;;; Types of question
        [question
            [is_question]
            [does_question]
            [did_question]
            [do_question]
            [can_question]
            [will_question]
            [where_question]
            [which_question]
            [what_question]
            ;;; includes use of 'how', e.g. 'how big'
            [size_question]
            [colour_question]

            ;;; [why_question]  ;;; to be added
            ]
        ;;;
        ;;; Now each question type is defined
        [is_question
            [is_v np_subj_sing complement]
        ]
;;;         [is_v np_subj_sing [loc_pp [a typenp_sing] adj]]
;;;             [is np_subj_sing loc_pp]
;;;             [is np_subj_sing a typenp_sing]
;;;             [is np_subj_sing adj]
        [are_question
            [are_v np_subj_pl complement]
        ]
        [does_question
            [does np_subj_sing agent_dovp]
        ]
        [did_question
            [did np_subj_sing agent_dovp]
            ]
        [can_question
            ;;; maybe this should be restricted to agent_np_subj
            [can np_subj_sing agent_dovp]
            [can np_subj_sing agent_dovp and agent_dovp]
            ]
        [will_question
            ;;; maybe this should be generalised beyond agent_np_subj
            [will agent_np_subj agent_dovp]
            ]
        ;;;
        ;;; a Horrible Hack to illustrate conjunctive subject
        [do_question
            [do agent_np_subj and agent_np_subj agent_dovp]
            ]
        [do_question
            [do agent_np_pl agent_dovp]
            ]
        [where_question
            ;;; Clumsy. Needs to be generalised.
            [where is np_subj_sing]
            [where are np_subj_pl]
            [what is the location of np_obj]
            [where can I find np_obj]
            ]
        ;;;
        ;;; E.g. 'which block is in the box' 'which blue ball is on the big table',
        ;;; 'Which block on the table is not red' etc.
        [which_question
            [which_word typenp_sing is_verb complement]
            [which_word typenp_sing agent_doesvp]
            ]
        ;;; E.g. 'what/who/which is in the box' 'what/who/which is on the big table',
        ;;; 'what/who/which is not red' etc.
        [what_question
            [what_word is_verb complement]
            [what_word agent_doesvp]
        ]
        [is_verb [is_v] [is_v not]]
        [are_verb [are_v] [are_v not]]
        [size_question
            [how how_sizeadj is_v np_subj_sing]
            [what what_sizeadj is_v np_subj_sing]
            ]
        [colour_question
            [what colour is_v np_subj_sing]
            [what is_v the colour of np_obj]
            ]
        ;;;
        ;;; Commands
        [command
            [stop]
            [start]
            [don"t]
            [don"t command]
            [not now]
            [agent_dovp]
            ;;; [command and command]
            [after assertion  command]
            [command or command]
            ]
        ;;;
        ;;; Predications
        [complement_simple
        ;;; Describe smething using a typenp
        ;;; A typenp is a complex phrase that can function as common noun
        ;;; e.g. 'house' 'red house' 'big red house' 'big red house on the corner'
            [a typenp_sing]
        ;;; Describe something using an adjective or adjectival phrase
            [adj]
        ;;; simple prepositional phrases don't involve recursion
        ;;; E.g. 'the red block is on the big green tray'
            [loc_pp]
            [to_pp]
        ;;;
        ;;; 'comp' = comparative
        ;;; e.g. the red block is taller/further/etc. than the green cup
            [comp than np_obj]
        ;;;
        ;;; Now a messy collection of cases involving prepositions
        ;;; e.g. between X and Y
            [relprep np_obj and np_obj]
        ]

        [complement
            ;;; negated complement is a complement, etc.
            [not complement_simple]
            ;;; hacks to allow a bit more complexity
            [complement_simple and complement_simple]
            [complement_simple and not complement_simple]
            [complement_simple or complement_simple]
            [complement_simple or not complement_simple]
            [complement_simple]
            [complement_simple and complement]
        ]
        ;;; Types of answer to questions
        [answer
            [yesno_answer]
            [dont_know_answer]
            [thing_answer]
            [place_answer]
            [size_answer]
            [colour_answer]
            [orient_answer]
            ]
        [yesno_answer [yes] [no] [maybe]]
        ;;;
        ;;; How to say you cannot answer
        [dont_know_answer
            ;;; this is clumsy
            [I do not know]
            [I do not have the information]
            ]
        [thing_answer [np_subj_sing]]
        [place_answer
            [loc]
            [not loc]
            [loc_pp]
            [not loc_pp]
            [where np_subj_sing is]
            ]

        ;;;
        [size_answer
            [sizeadj]
            [sizecomp than np_subj_sing]
            [as sizeadj as np_subj_sing]
            [the same size as np_subj_sing]
            ]
        [colour_answer
            [colouradj]
            [the same colour as np_subj_sing]
            ]
        [orient_answer [orientadj]]
        ;;;
        ;;; types of comparison - size, height or distance
        [comp [sizecomp] [htcomp] [distcomp]]
        ;;;
        ;;; varieties of adjectives and adjectival expressions
        [adj
            [simpadj]
            [non simpadj]
            ]
        ;;; Several kinds of simple adjectives defined later
        [simpadj
            [sizeadj]
            [colouradj]
            [shapeadj]
            [orientadj]
            ]
        ;;;
        ;;; A sequence of adjectives. (Really needs stricter control, e.g. to rule
        ;;; out things like 'the red old blue big red house'!)
        [adjes [adj] [adj adjes]]
        ;;;
        ;;; A typenp is either a noun, or sequence of adjectives and a noun or a
        ;;; typenp followed by a prepositional phrase
        ;;; for some reason, the recursive version doesn't work.
        [typenp_sing
            [noun_sing]
            [adjes noun_sing]
            [noun_sing rel_descr]
            [adjes noun_sing rel_descr]
        ]
        [typenp_pl
            [noun_pl]
            [adjes noun_pl]
            [noun_pl rel_descr_pl]
            [adjes noun_pl rel_descr_pl]
            ]
        ;;;
        ;;; determinate NP 'the ....something...'
        [detnp [det_sing typenp_sing]]
        ;;; plural version
        [detnp_pl [det_pl typenp_pl]]
        ;;;
        ;;; Varieties of noun phrase including pronouns, names, determinate NPs
        ;;; and things like 'the other block' 'the other house on the corner' etc.
        [othernp [det_sing other typenp_sing]]
        ;;; plural version
        [othernp_pl [det_pl other typenp_pl]]
        ;;;
        ;;; Hackery to do with pronouns and names.
        ;;; Need a more systematic separation in cases suited for
        ;;; subject, object, possessive, etc.
        ;;; First a hack: noun phrases can be nominative (subject) or accusative (object)
        ;;; Now redundant. Use only np_obj and np_subj_sing/pl
        ;;; [np  [np_subj_sing] [np_obj] ]
        ;;;
        ;;; nominative noun phrase
        ;;; Subjects

        [np_subj_sing
            [pos_np_sing]
            [agent_np_subj]
            [thing_name]
            [thing_pronoun_sing]
            [nonagent_np]
            [detnp]
            [othernp]
            ]
        [np_subj_pl
;;;         [np_subj_sing and np_subj_sing]
            [agent_np_subj_pl]
            [thing_name and thing_name]
            [thing_pronoun_pl]
            [pos_np_pl]
            [detnp_pl]
            [othernp_pl]
            ]
        ;;;
        ;;; accusative noun phrase.
        ;;; allow plural forms
        [np_obj
            [agent_np_obj]
            [agent_np_obj_pl]
            [nonagent_np]
            [nonagent_np_pl]
            [pos_np_sing]
            [pos_np_pl]
            [detnp_pl]
            ]
        ;;; 'Atomic' noun phrases, 'Box2' 'it' 'he' 'joe'
        [agent_np_subj [person_name] [person_pronoun_subj]]
        [agent_np_subj_i [person_pronoun_subj_i]]
        [agent_np_subj_you [person_pronoun_subj_you]]
        ;;; Plural version
        [agent_np_subj_pl
            [person_name and person_name]
            [person_pronoun_subj_pl]
        ]
        [agent_np_obj [person_name] [person_pronoun_obj]]
        [agent_np_obj_pl [person_name and person_name] [person_pronoun_obj_pl]]
        ;;;
        ;;; Hard to define non-agent NP
        [nonagent_np
            [thing_name]
            [thing_pronoun_sing]
            [detnp]
            [othernp]
            ]
        [nonagent_np_pl
            [thing_name and thing_name]
            [detnp_pl]
            [othernp_pl]
            ]
        ;;; Assume the double quote(") followed by s is used for
        ;;; possessives
        ;;; a Hack to allow 's' to be used after " as in [Nick"s]
;;;     [pos_suffix [" s]]
        [person_pos [person_pronoun_pos_sing] [person_pronoun_pos_pl]]
        [possessive
            [person_name " s]
            [nonagent_np " s]
;;;             [person_name pos_suffix]
;;;             [nonagent_np pos_suffix]
            [person_pos]
        ]
        ;;;"his car" "the block"s owner" "the car"s big box"
        ;;; we should have a plural form also
        [pos_np_sing [possessive typenp_sing] ]
        [pos_np_pl [possessive typenp_pl] ]
        ;;;
        ;;; Relative descriptive extensions to a noun phrase
        ;;; e.g. 'which is on the left of the blue block', or on 'the left of the blue block'
        [rel_descr
            [which is loc_pp]
            [that is loc_pp]
            [loc_pp]
            ]
        [rel_descr_pl
            [which are loc_pp]
            [that are loc_pp]
            [loc_pp]
            ]
        ;;; things that can come after 'move' etc with no direct object
        [move_loc
            [source_pp target_pp]
            [target_pp source_pp]
            [source_pp]
            [target_pp]
            [to_pp]
        ]
        ;;; things that can come after put, place, etc.
        [put_loc
            [np_obj dest_pp]
            [np_obj]
        ]
        ;;; things that can come after 'push' etc with direct object
        [push_obj
            [np_obj move_loc]
            [np_obj]
        ]

        ;;; using 'pick' and 'up'
        [pick_obj
            [up np_obj source_pp]
            [np_obj up source_pp]
            [up np_obj]
            [np_obj up]
        ]
        ;;;
        ;;; Varieties of verb phrases -- possibly needs more subdivisions
        ;;; depends in part on type of verb, hence verb subdivisions
        [agent_doesvp
            [does_putverb np_obj]
            [does_putverb_pp np_obj dest_pp]
            [does_pushverb push_obj]
            [does_giveverb np_obj np_obj]
            [does_moveverb move_loc]
            ;;; 'touches the box' 'paints the ball' 'nudges the block on the table'
            [does_to_np np_obj]
            ;;;
            ;;; e.g. 'bridges X and Y', 'separates X and Y'
            [does_to_np_and_np np_obj and np_obj]
            ]
        [agent_dovp
            [do_putverb_pp np_obj dest_pp]
            [do_putverb np_obj]
            [do_getverb_pp np_obj move_loc]
            [do_getverb np_obj]
            [do_pickverb pick_obj]
            [do_pushverb push_obj]
            [do_giveverb np_obj np_obj]
            [do_moveverb move_loc]
            [do_moveverb]
            [do_sensevp np_obj]
            ]
        ;;; hacks (temporary)
        [do_sensevp [see] [look at] [feel] [touch] [listen to]]
        ;;;
        ;;; Less restricted verb phrases
        [vp
            [agent_doesvp]
            ;;; may add others
        ]
        ;;;
        ;;; Varieties of prepositional phrase (needs cleaning up)
        ;;; Destinations: to towards, etc.
        ;;; give, move, put, send ....
        ;;; Separations far from, away from, ...
        [front_prepp [in front of]]
        [next_pp [next_prep to]]
        [far_pp [far_prep from]]
        [target_pp
            [to_pp]
            [target_prep np_obj]
            [front_prepp np_obj]
            [next_pp np_obj]
            [next_pp loc_type]
            [far_pp np_obj]
            [far_pp loc_type]
            [target_prep loc_type]
            [target_prep loc_pp]
        ]
        ;;; put place leave drop locate (relative to object or to location)
        [dest_pp
            [to_pp]
            [dest_prep np_obj]
            [dest_prep loc_type]
            [front_prepp np_obj]
            [next_pp np_obj]
            ;;; should we allow here, there, outside ??
            [loc]
            ]
        ;;; Sources/origins from, from near, from under
        [source_pp
            [source_prep np_obj]
            [front_prepp np_obj]
            [source_prep front_prepp np_obj]
            [source_prep next_pp np_obj]
            [source_prep loc_type]
            ;;; from at the table, form under the box, etc.
            [source_prep loc_pp]
            ]
        ;;;
        ;;; at/near the side/top/front of ...
        [loc_pp
            [loc_prep np_obj]
            [front_prepp np_obj]
            [next_pp np_obj]
            [loc_prep loc_type]
            ]
        ;;;
        ;;; Things like to the right of..., at the front of...,this side ofetc.
        ;;;;
        [loc_type
            [det_sing loc_rel of np_obj]
            ;;; ...the left/right side of...
            [det_sing loc_hor loc_hor_type of np_obj]
            ;;; ... this/that side of ...
            [loc_det loc_hor_type of np_obj]
            ;;; ... the front/back face of ...
            [det_sing loc_face of np_obj]
            [det_sing loc_face loc_face_type of np_obj]
            ;;; ... this/that face of ....
            [loc_det loc_face_type of np_obj]
            ;;;
            [front_prepp np_obj]
            ]
        [loc_rel [loc_vert] [loc_hor] [loc_face] ]
        [to_pp
            [to loc_type]
        ]
    ],
;


;;; This could be optional
setup(robogram, robolex);


;;; Procedure for generating whole sentene instances of the grammar
define generate_random_sentences(gram, lex, num);
    lvars sentence;
    repeat num times
        generate_category(oneof([assertion question command]), gram, lex) -> sentence;
        sentence ==>
        readline() ->;
        S(sentence)==>
        readline() ->;
    endrepeat;
enddefine;

/*
;;; SAMPLE OPTIONAL TRACING COMMANDS

trace np_subj_sing;
trace np_subj_pl;
trace question;
trace assertion;

trace pos_np_sing;
trace pos_np_pl;
trace agent_np_subj;
trace thing_name;
trace thing_pronoun_sing;
trace thing_pronoun_pl;
trace nonagent_np;
trace detnp;
trace othernp;
trace possessive;
trace typenp_sing;
trace typenp_pl;
trace detnp;

*/

/*
;;; TESTS

S([the car is red]) =>
S([the car was red]) =>

S([put the red thing in front of the car]) ==>
S([put the red thing near Nick]) ==>
S([put the red thing to the left of Nick]) ==>
S([move the red thing to the left of the blue thing]) ==>
S([move the red thing to in front of the blue thing]) ==>
no_parse_found.datalist.length ==>
no_parse_found.datalist ==>
S([move the red thing from the left of the blue thing]) ==>
S([move the red thing from in front of the blue thing]) ==>
dest_pp([to the left of the blue thing]) ==>
dest_pp([in front of the blue thing]) ==>
to_pp([to the left of the blue thing]) ==>
to_pp([to in front of the blue thing]) ==>
to_pp([to the left of Nick]) ==>

S([put the red thing to the left of the table]) ==>

S([put the square near the red car]) ==>

S([what is near the red ball])==>
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
S([is the red square blue])==>

S([is the red square on the left of the circle])==>
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
S([is Aaron"s red car big and heavy]) ==>
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
S([look at the red ball and grab it from under the box]) ==>
S([look at the red ball and put it next to the box]) ==>
S([look at the red ball and put it close to the box]) ==>

S([take the ball])==>
S([take the ball to the kitchen])==>
S([take the ball to the triangle])==>
S([take the ball to the kitchen and put the box in the bedroom])==>
S([put the box in the bedroom and stop])==>
S([stop]) ==>

S([after the ball is in the kitchen  put the box in the bedroom])==>
S([he is red ])==>
S([the book is red ])==>

S([Nick"s car is red ]) ==>
S([get Nick"s car]) ==>
S([take the ball to my car]) ==>
S([give her Aaron"s car]) ==>
S([Aaron"s car is on the table]) ==>
np_subj_sing([Aaron"s car])==>
complement([on the table]) ==>
S([the red car"s bonnet is black]) ==>
S([the car"s bonnet is on the cow]) ==>
S([the red car"s bonnet is on the cow]) ==>

np_subj_sing([the red car"s bonnet]) ==>

question([where is the red car"s bonnet]) ==>
assertion([where is the red car"s bonnet]) ==>
S([where is the red car"s bonnet]) ==>
np_subj_sing([where is the red car"s bonnet]) ==>
np_subj_sing([where is the red car"s])==>
the red car"s bonnet]) ==>
S([where is the other bonnet]) ==>
question([where is the other bonnet]) ==>

S([which car is red]) ==>
np_subj_sing([Nick])==>
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
pos_np([the red car"s bonnet])==>
pos_suffix([" s])==>

no_parse_found.datalist.length ==>
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
np_subj_sing([his car])==>
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

generate_category("question", robogram, robolex)==>
generate_cat("question", robogram, robolex)==>

generate_category(oneof([assertion question command]), robogram, robolex)==>

;;; this generates a random sentence then pauses, then if you
;;; press return it parses the sentence.
;;; Then press return to continue
generate_random_sentences(robogram, robolex, 35);
generate_random_sentences(robogram, robolex, 5);

no_parse_found.datalist ==>
no_parse_found.datalist.length ==>
*/

endsection;

/* --- Revision History ---------------------------------------------------
--- Aaron Sloman, Oct 19 2010
        Revised version of part of newplaylex.p
 */
