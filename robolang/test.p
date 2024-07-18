
uses teaching

;;; newgrammar.p will be compiled

compilehere
    robolex.p
    robogram.p
;

vars S_tree;

S([move the big red box on the tray onto the top of the block on the
    left side of Jeremy"s triangular horse])
    -> S_tree;

S_tree ==>

** [S [command [agent_dovp
                [do_pushverb move]
                [push_obj [np_obj [nonagent_np
                                   [detnp [det_sing the]
                                          [typenp_sing
                                           [adjes [adj [simpadj [sizeadj big]]]
                                                  [adjes [adj [simpadj [colouradj red]]]]]
                                           [noun_sing box]
                                           [rel_descr [loc_pp [loc_prep on]
                                                              [np_obj [nonagent_np
                                                                       [detnp [det_sing the]
                                                                              [typenp_sing
                                                                               [noun_sing tray]]]]]]]]]]]
                          [move_loc [target_pp [target_prep onto]
                                               [loc_type [det_sing the]
                                                         [loc_rel [loc_vert top]]
                                                         of
                                                         [np_obj [nonagent_np
                                                                  [detnp [det_sing the]
                                                                         [typenp_sing
                                                                          [noun_sing block]
                                                                          [rel_descr [loc_pp [loc_prep

            on]
                                                                                             [loc_type

            [det_sing

                      the]

            [loc_hor

                     left]

            [loc_hor_type

             side]

            of

            [np_obj

                    [pos_np_sing

                     [possessive

                      [person_name

                       Jeremy]
                        " s
                     ]

                     [typenp_sing

                      [adjes

                             [adj

                                  [simpadj

                                           [shapeadj

                                                     triangular]]]]

                      [noun_sing

                                 horse]]]]]]]]]]]]]]]]]]


;;;;;;

;;; This can be used to display a graphical version of the parse tree in the
;;; Poplog editor, Ved or XVed
uses showtree;

showtree(S_tree);

;;; A screenshot of the result is here
;;;
;;; http://www.cs.bham.ac.uk/research/projects/poplog/examples/robolang/parse-tree.png
