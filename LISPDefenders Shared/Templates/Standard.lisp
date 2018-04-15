
(template 200 50
(let [(x 📦) (y 📦) (z 📦)] x))

(template 200 50
(let [(x 📦) (y 📦) (z 📦)] y))

(template 200 50
(let [(x 📦) (y 📦) (z 📦)] z))

(template 100 100
(let [(x 📦) (y 📦) (z 📦)] (' x y)))

(template 100 100
(let [(x 📦) (y 📦) (z 📦)] (' y z)))

(template 100 100
(let [(x 📦) (y 📦) (z 📦)] (' x z)))

(template 50 200
(let [(x 📦) (y 📦) (z 📦)] (' x y z)))

(template 125 125
((λ (x) 📦) 📦))

(template 125 125
((λ (x) x) 📦))

(template -300 400
((λ (x y)
  (if (> 📦 📦)
     x
     y))
  🍕 💣))

(template -300 400
((λ (x y)
  (if (< 📦 📦)
     x
     y))
  🍕 💣))

(template -300 400
((λ (x y)
  (if (< x y)
     🍕
     💣))
  📦 📦))

(template -1600 1600
((λ ()
 (first (rest (rest
   (cons 🎁 (' 🍕 📦 📦))))))))

(template -1800 1800
((λ ()
 (rest (rest (cons 🎁
  (first (' (' 🍕 📦) 📦))))))))

(template -77 77
(* 7 (* 7 (* 7 🍩)))

(template -3200 1600
((λ ()
 (rest (rest (rest
   (cons 🎁 (' 🍕 📦 📦))))))))

(template -3200 2400
((λ (x y)
  ((if (> x 📦) first rest)
   (' y 📦 💣 💣))) 🍩 🎁))

(template -2400 2500
((λ (x y) (cond
      [(not (or 🎁 🎁)) 🎁]
   [(and 🎁 🎁 🎁) 💣] [🎁 🎁]
   [(or false 🍩 🍩 🍩 🍩 🍩) 🍣])) 1 0))

(template -1200 800
(if (or false 💣 (> 📦 🍩) false)
  ((λ (x) (rest (' x x (' x)))) 🎁)
    (' 💣 💣 nil nil nil nil nil  💣 💣)))

(template -1200 800
(if (and false 💣 (> 📦 🍩) false)
  ((λ (x) (rest (' x x (' x)))) 🎁)
    (' 💣 🎁 nil nil nil nil nil  💣 💣)))

(template -800 800
(((λ (x) (λ (y)
   (if (> x y)
     (* x 4)
     (* y 3)))) 📦)
 🌮))

(template -800 800
(((λ (x) (λ (y)
   (if (< x y)
     (* x 4)
     (* y 3)))) 📦)
 🌮))

(template -800 800
((λ (x) (cond
  ((= x 🍕) (' nil nil nil 💣))
  ((= x 🌮) (* 1 🍩))
  ((= x 🍕) 🍣))) 📦))
