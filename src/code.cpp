#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
String process_french(String date) {
  date.replace_all("le ", "");
  date.replace_all("Le ", "");
  date.replace_all("1er", "01");
  return date;
}