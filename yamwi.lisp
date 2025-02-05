;; 'asksign1' is redefined to avoid asking the user
;; about the sign of constants. Instead of calling
;; macro 'ask', we return an error message of type
;; 'yamwi1', which will be later managed by the php script.
(defun asksign1 ($askexp)
  (let ($radexpand)
    (declare (special $radexpand))
    (sign1 $askexp))
  (cond ((has-int-symbols $askexp)
	 '$pnz)
	((member sign '($pos $neg $zero $imaginary) :test #'eq) sign)
	((null odds)
	 (setq $askexp (lmul evens)
	       sign (cdr (assol $askexp locals)))
	 (do ()
	     (nil)
	   (cond ((member sign '($zero |$Z| |$z| 0 0.0) :test #'equal)
		  (tdzero $askexp) (setq sign '$zero) (return t))
		 ((member sign '($pn $nonzero |$N| |$n| $nz $nonz $non0) :test #'eq)
		  (tdpn $askexp) (setq sign '$pos) (return t))
		 ((member sign '($pos |$P| |$p| $positive) :test #'eq)
		  (tdpos $askexp) (setq sign '$pos) (return t))
		 ((member sign '($neg |$N| |$n| $negative) :test #'eq)
		  (tdneg $askexp) (setq sign '$pos) (return t)))
	   (merror "yamwi1a ~M yamwi1b" ($listofvars $askexp)))
	 (if minus (flip sign) sign))
	(t (if minus (setq sign (flip sign)))
	   (setq $askexp (lmul (nconc odds (mapcar #'(lambda (l) (pow l 2)) evens))))
	   (do ((dom (cond ((eq '$pz sign) "  positive or zero?")
			   ((eq '$nz sign) "  negative or zero?")
			   ((eq '$pn sign) "  positive or negative?")
			   (t "  positive, negative, or zero?")))
		(ans (cdr (assol $askexp locals))))
	       (nil)
	     (cond ((and (member ans '($pos |$P| |$p| $positive) :test #'eq)
			 (member sign '($pz $pn $pnz) :test #'eq))
		    (tdpos $askexp) (setq sign '$pos) (return t))
		   ((and (member ans '($neg |$N| |$n| $negative) :test #'eq)
			 (member sign '($nz $pn $pnz) :test #'eq))
		    (tdneg $askexp) (setq sign '$neg) (return t))
		   ((and (member ans '($zero |$Z| |$z| 0 0.0) :test #'equal)
			 (member sign '($pz $nz $pnz) :test #'eq))
		    (tdzero $askexp) (setq sign '$zero) (return t)))
	     (merror "yamwi1a ~M yamwi1b" ($listofvars $askexp)))
	   (if minus (flip sign) sign))))