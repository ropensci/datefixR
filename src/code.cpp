#include <Rcpp.h>
using namespace Rcpp;
#include <string>
#include <regex>
#include "translate.h"

// [[Rcpp::export]]
String process_french(String date) {
  date.replace_all("le ", "");
  date.replace_all("Le ", "");
  date.replace_all("1er", "01");
  return date;
}

// [[Rcpp::export]]
String process_russian(String date) {
  date.replace_all("марта", "март");
  date.replace_all("Марта", "Март");
  date.replace_all("августа", "август");
  date.replace_all("Августа", "Август");
  return date;
}

// [[Rcpp::export]]
void imputemonth(Nullable<String> monthImpute_) {
  if (monthImpute_.isNull()) {
    stop(_("Missing month with no imputation value given \n"));
  } 
}

// [[Rcpp::export]]
void imputeday(Nullable<String> dayImpute_) {
  if (dayImpute_.isNull()) {
    stop(_("Missing day with no imputation value given \n"));
  }
}


// [[Rcpp::export]]
void checkday(Nullable<NumericVector> dayImpute) {
  if (!dayImpute.isNull()) {
    NumericVector dayImpute_(dayImpute); 
    if (!NumericVector::is_na(dayImpute_[0])) {
      if (dayImpute_[0] < 1 || dayImpute_[0] > 31) {
        stop(_("day.impute should be an integer between 1 and 31\n"));
      }
      if (floor(dayImpute_[0]) != dayImpute_[0]) {
        stop(_("day.impute should be an integer\n"));
      }
    }
  }
}
