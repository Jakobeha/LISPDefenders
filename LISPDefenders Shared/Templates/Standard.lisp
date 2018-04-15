
(template 12
(let [(x 📦)
      (y 📦)]
   x))

(template 9
(if (> 📦 🍕)
   💣
   ('    🎁)))

(template 5
(if (> 📦 🍩)
   ((lambda (x) (' x x)) 🎁)
   (' 💣 💣 💣)))

(template 7
(((lambda (x)
     (lambda (y)
        (if (> x y)
           (* x 4)
           (* y 3)))) 📦) 🌮))

(template 4
((lambda (x)
    (cond ((= x 🍕) (' nil nil nil 💣))
          ((= x 🌮) (* 1 🍩))
          ((= x 🍕) 🍣)))
 📦))
