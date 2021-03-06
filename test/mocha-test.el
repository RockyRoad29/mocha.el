
;;;; mocha-opts-file

(ert-deftest mocha-test/mocha-opts-file/return-correct-opts-file ()
  (mocha-test/with-sandbox
   (f-mkdir (f-join default-directory "test"))
   (f-mkdir (f-join default-directory "test" "unit"))
   (f-mkdir (f-join default-directory "test" "acceptance"))
   (f-mkdir (f-join default-directory "test" "integration"))
   (let ((unit-test-file (f-join default-directory "test" "unit" "test.coffee"))
         (unit-opts-file (f-join default-directory "test" "unit" "mocha.opts"))
         (acceptance-test-dir (f-join default-directory "test" "acceptance"))
         (acceptance-opts-file (f-join default-directory "test" "acceptance" "mocha.opts"))
         (integration-test-file (f-join default-directory "test" "integration" "test.coffee")))
     (f-touch unit-test-file)
     (f-touch unit-opts-file)
     (f-touch acceptance-opts-file)
     (f-touch integration-test-file)
     (should (equal (mocha-opts-file unit-test-file) unit-opts-file))
     (should (equal (mocha-opts-file acceptance-test-dir) acceptance-opts-file))
     (should-not (mocha-opts-file integration-test-file)))))


;;;; mocha-generate-command

(ert-deftest mocha-test/mocha-generate-command/return-command-including-mocha-opts-option ()
  (mocha-test/with-sandbox
   (f-mkdir (f-join default-directory "test"))
   (f-mkdir (f-join default-directory "test" "unit"))
   (f-mkdir (f-join default-directory "test" "integration"))
   (let ((unit-test-file (f-join default-directory "test" "unit" "test.coffee"))
         (unit-opts-file (f-join default-directory "test" "unit" "mocha.opts"))
         (integration-test-file (f-join default-directory "test" "integration" "test.coffee")))
     (f-touch unit-test-file)
     (f-touch unit-opts-file)
     (f-touch integration-test-file)
     (should (s-contains? (concat "--opts " unit-opts-file) (mocha-generate-command nil unit-test-file)))
     (should-not (s-contains? "--opts" (mocha-generate-command nil integration-test-file))))))

(ert-deftest mocha-test/mocha-generate-command/return-command-with-correct-reporter ()
  (mocha-test/with-sandbox
   (should (s-contains? "--reporter dot" (mocha-generate-command nil)))
   (let ((mocha-reporter "spec"))
     (should (s-contains? "--reporter spec" (mocha-generate-command nil))))))


;;;; mocha-find-project-root

(ert-deftest mocha-test/mocha-find-project-root/return-path-to-project-root ()
  (mocha-test/with-sandbox
   (should (f-same? (mocha-find-project-root) mocha-test/sandbox-path))
   (should (s-ends-with? "/" (mocha-find-project-root)))
   (let ((foo-dir (f-join default-directory "foo")))
     (f-mkdir foo-dir)
     (let ((default-directory foo-dir))
       (should (f-same? (mocha-find-project-root) mocha-test/sandbox-path))))))

(ert-deftest mocha-test/mocha-find-project-root/return-nil-unless-package-file-exist ()
  (mocha-test/with-sandbox
   (f-delete "package.json" :force)
   (should-not (mocha-find-project-root))))
