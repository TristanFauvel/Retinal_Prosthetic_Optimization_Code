global viewing_distance
lang = 'en';
if strcmp(lang, 'en')
    instructions_l1 = 'Thank you for participating in this experiment.';
    instructions_l2 = ['\n\n Please sit at a viewing distance of about ', num2str(floor(100*viewing_distance)), ' cm from the monitor.'];
    instructions_l3 = '\n\n Press enter when you are ready to learn the instructions.';
    start_instructions = [instructions_l1, instructions_l2, instructions_l3];
    
    preference_l1 = 'The image corresponds to a distorted version of a letter (printed above),';
    preference_l2 = '\n indicate which one you find the most recognizable or least distorted using the left or right arrows.';
    preference_l3 = '\n You can cancel a strike by pressing C.';
    preference_l4 = '\n\n Press enter to start.';
    preference_instructions = [preference_l1 preference_l2 preference_l3 preference_l4];
    
    E_l1 = 'The image corresponds to a distorted version of a letter E,';
    E_l2 = '\n which can take 4 different orientations.';
    E_l3 = '\nIndicate the orientation by pressing the corresponding arrow keys.';
    E_l4_v1 = '\n You can cancel a strike by pressing C.Press enter to start.';
    E_l4_v2 = '\n You cannot cancel your strike. Press enter to start.';
    E_instructions_v1 = [E_l1, E_l2, E_l3, E_l4_v1];
    E_instructions_v2 = [E_l1, E_l2, E_l3, E_l4_v2];
    
    Snellen_l1 = 'The image corresponds to a distorted version of a letter.';
    Snellen_l2 = '\n Press the keyboard to identify the letter.';
    Snellen_l3 = '\n\n You cannot cancel your strike.';
    Snellen_l4 = '\n\n Press enter to start.';
    Snellen_instructions = [Snellen_l1,Snellen_l2,Snellen_l3,Snellen_l4];
elseif strcmp(lang, 'fr')
    instructions_l1 = 'Merci de participer à cette expérience.';
    instructions_l2 = ['\n\n Asseyez-vous à environs ', num2str(floor(100*viewing_distance)), ' cm de l''écran.'];
    instructions_l3 = '\n\n Appuyez sur ''entrée'' pour voir les instructions.';
    start_instructions = [instructions_l1, instructions_l2, instructions_l3];
    
    preference_l1 = 'Quand des images s''affichent, indiquez celle pour laquelle vous trouvez la lettre';
    preference_l2 = '\n la plus reconnaissable ou la moins déformée, en utilisant les flèches gauche/droite. Cette lettre est affichée au dessus.';
    preference_l3 = '\n Vous pouvez annuler votre réponse en appuyant sur C.';
    preference_l4 = '\n\n Appuyez sur ''entrée'' pour commencer.';
    preference_instructions = [preference_l1 preference_l2 preference_l3 preference_l4];    
   
    E_l1 = 'Les images correspondent à une version de la lettre E,';
    E_l2 = '\n qui peut prendre quatre orientations.';
    E_l3 = '\n Indiquez l''orientation en appuyant sur les flèches.';
    E_l4_v1 = '\n Vous pouvez annuler votre réponse en appuyant sur C. Appuyez sur ''entrée'' pour commencer.';
    E_l4_v2 = '\n Vous ne pouvez pas annuler vos réponses. Appuyez sur ''entrée'' pour commencer.';
    E_instructions_v1 = [E_l1, E_l2, E_l3, E_l4_v1];
    E_instructions_v2 = [E_l1, E_l2, E_l3, E_l4_v2];

    Snellen_l1 = 'Les images correspondent à une version déformée d''une lettre.';
    Snellen_l2 = '\n Utilisez le clavier pour indiquer la lettre.';
    Snellen_l3 = '\n\n Vous ne pouvez pas annuler vos réponses.';
    Snellen_l4 = '\n\n Appuyez sur ''entrée'' pour commencer.';
    Snellen_instructions = [Snellen_l1,Snellen_l2,Snellen_l3,Snellen_l4];
end