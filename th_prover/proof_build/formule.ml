type formule =
	Bottom
    |Var of char
    |Not of formule
    |And of formule * formule
    |Or of formule * formule
    |Imp of formule * formule


(*Vérifie si f1 possède un pattern contenu dans f1. Par exemple, f1 = And(Not (Var 'a'),Var 'b') et f2 = And(Not(Bottom), Or((Var 'a),Var 'b'))*)
(*A remarquer que l'ordre des arguments compte ici, f1 est le pattern et f2 la formule suivant ce pattern*)
let is_f_equiv (f1:formule) (f2:formule):bool =
    let dict = Hashtbl.create 42 in
    let rec aux o t = match o,t with
        |Bottom,Bottom -> true
        |Var _ ,_ ->( try (if (Hashtbl.find dict o) <> t then false else (Hashtbl.replace dict o t; true))
                       with Not_found -> Hashtbl.add dict o t;true)
        |Not(a), Not(b) -> aux a b
        |And(a1,b1),And(a2,b2) -> (aux a1 a2) && (aux b1 b2)
        |Or(a1,b1),Or(a2,b2) -> (aux a1 a2) && (aux b1 b2)
        |Imp(a1,b1),Imp(a2,b2) -> (aux a1 a2) && (aux b1 b2)
        |_ -> false
    in aux f1 f2;;

(*donne un string représentant une formule f*)
let rec formule_to_string ?(clean = true) f = 
    if clean then match f with
        |Bottom ->  "┴"
        |Var a -> Char.escaped (Char.uppercase_ascii a)
        |Not a -> "¬(" ^ (formule_to_string a) ^ ")"
        |And(a,b) ->  "("^ (formule_to_string a) ^ ")^(" ^ (formule_to_string b) ^ ")"
        |Or(a,b) -> "("^ (formule_to_string a) ^ ")v(" ^ (formule_to_string b) ^ ")"
        |Imp(a,b) -> "("^ (formule_to_string a) ^ ")->(" ^ (formule_to_string b) ^ ")"
    else match f with
        |Bottom ->  "┴"
        |Var a -> Char.escaped a
        |Not a -> "Not(" ^ (formule_to_string ~clean:false a) ^ ")"
        |And(a,b) ->  "And("^ (formule_to_string ~clean:false a) ^ "," ^ (formule_to_string ~clean:false b) ^ ")"
        |Or(a,b) -> "Or("^ (formule_to_string ~clean:false a) ^ "," ^ (formule_to_string ~clean:false b) ^ ")"
        |Imp(a,b) -> "Imp("^ (formule_to_string ~clean:false a) ^ "," ^ (formule_to_string ~clean:false b) ^ ")"



(*print *)
let print_formule f = print_string (formule_to_string f)

