# allow the script to be executed chmod +x ./coverage_script.sh
echo '========== Executing tests...'
flutter test --coverage # `coverage/lcov.info` file
echo '========== Converting  cov.info into html...'
genhtml coverage/lcov.info -o coverage/html # converts coverage report in html
echo '========== Opening html coverage report...'
open coverage/html/index.html
echo '========== Report is complete :)'