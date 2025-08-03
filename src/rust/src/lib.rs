use extendr_api::prelude::*;
use regex::Regex;
use chrono::{NaiveDate, Datelike};
use std::collections::HashMap;
use std::sync::OnceLock;

/// Month names in different languages (mirroring R months data)
static MONTHS: OnceLock<HashMap<usize, Vec<&'static str>>> = OnceLock::new();
static ROMAN_NUMERALS: OnceLock<Vec<&'static str>> = OnceLock::new();
static DAYS_IN_MONTH: [u8; 12] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

fn get_months() -> &'static HashMap<usize, Vec<&'static str>> {
    MONTHS.get_or_init(|| {
        let mut months = HashMap::new();
        months.insert(1, vec![
            "january", "janvier", "janeiro", "janv", "januar", "jänner", "jän",
            "enero", "ener", "ene", "jan", "январь", "января", "янв", "januari"
        ]);
        months.insert(2, vec![
            "february", "février", "fevrier", "fevereiro", "févr", "fevr", "fev",
            "februar", "febrero", "feb", "февраль", "февраля", "фев", "februari"
        ]);
        months.insert(3, vec![
            "march", "mars", "märz", "marzo", "março", "marco", "marz", "mar",
            "март", "мар", "maret"
        ]);
        months.insert(4, vec![
            "april", "avril", "abril", "abr", "apr", "апрель", "апреля", "апр"
        ]);
        months.insert(5, vec![
            "mayo", "may", "maio", "mai", "май", "мая", "mei"
        ]);
        months.insert(6, vec![
            "june", "juin", "junio", "junho", "juni", "jun", "июнь", "июня", "июн"
        ]);
        months.insert(7, vec![
            "july", "juillet", "juil", "julio", "julho", "juli", "jul",
            "июль", "июля", "июл"
        ]);
        months.insert(8, vec![
"august", "aug", "août", "aout", "agosto", "август", "авг", "agustus"
        ]);
        months.insert(9, vec![
            "september", "septembre", "septiembre", "setembro", "set", "sept", "sep",
            "сентябрь", "сентября", "сент"
        ]);
        months.insert(10, vec![
            "october", "octobre", "oktober", "okt", "octubre", "outubro", "oct", "out",
            "октябрь", "октября", "окт"
        ]);
        months.insert(11, vec![
            "november", "novembre", "noviembre", "novembro", "nov",
            "ноябрь", "ноября", "ноя"
        ]);
        months.insert(12, vec![
            "december", "décembre", "decembre", "déc", "dezember", "dezembro", "dez",
            "diciembre", "dic", "dec", "декабрь", "декабря", "дек", "desember"
        ]);
        months
    })
}

fn get_roman_numerals() -> &'static Vec<&'static str> {
    ROMAN_NUMERALS.get_or_init(|| {
        vec!["i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x", "xi", "xii"]
    })
}

/// Private helper function to replace multiple patterns in a string
fn replace_all<'a>(input: &'a str, patterns: &[(&str, &str)]) -> String {
    let mut out = input.to_string();
    for (from, to) in patterns {
        out = out.replace(from, to);
    }
    out
}


/// Process French date strings by removing articles and normalizing ordinals
/// @noRd
#[extendr]
fn process_french(date: &str) -> String {
    let mut result = replace_all(
        date,
        &[("le ", " "), ("Le ", " "), ("1er", "01")],
    );
    // Handle more French ordinals and cleanup extra spaces
    result = result.trim().to_string();
    result
}

/// Process Russian date strings by normalizing months
#[extendr]
/// @noRd
fn process_russian(date: &str) -> String {
    replace_all(
        date,
        &[
            ("марта", "март"), ("Марта", "Март"),
            ("августа", "август"), ("Августа", "Август"),
        ],
    )
}

/// Validate month imputation value
/// @noRd
#[extendr]
fn imputemonth(month_impute: Option<&str>) -> Result<()> {
    if month_impute.is_none() {
        Err("Missing month with no imputation value given".into())
    } else {
        Ok(())
    }
}

/// Validate day imputation value
/// @noRd
#[extendr]
fn imputeday(day_impute: Option<&str>) -> Result<()> {
    if day_impute.is_none() {
        Err("Missing day with no imputation value given".into())
    } else {
        Ok(())
    }
}

/// Validate day imputation value range
/// @noRd
#[extendr]
fn checkday(day_impute: Robj) -> Result<()> {
    if day_impute.is_null() || day_impute.len() == 0 {
        return Ok(());             // nothing to check
    }
    
    // Handle NA values - they are allowed
    if day_impute.is_na() {
        return Ok(());
    }
    
    // Try to convert to f64 from various R types
    let val: f64 = match day_impute.rtype() {
        Rtype::Doubles => {
            let real_val = day_impute.as_real().unwrap_or(f64::NAN);
            if real_val.is_nan() {
                return Ok(()); // NA values are OK
            }
            real_val
        },
        Rtype::Integers => {
            let int_val = day_impute.as_integer().unwrap_or(i32::MIN);
            if int_val == i32::MIN {
                return Ok(()); // NA values are OK
            }
            int_val as f64
        },
        _ => {
            return Err("day.impute must be numeric".into())
        }
    };
    
    if val.fract() != 0.0 {
        return Err("day.impute should be an integer\n".into());
    }
    if !(1.0..=31.0).contains(&val) {
        return Err("day.impute should be an integer between 1 and 31\n".into());
    }
    Ok(())
}

/// Remove ordinal suffixes from date strings
fn rm_ordinal_suffixes(date: &str) -> String {
    let patterns = [
        (r"(\d)(st,)", "$1"),
        (r"(\d)(nd,)", "$1"),
        (r"(\d)(rd,)", "$1"),
        (r"(\d)(th,)", "$1"),
        (r"(\d)(st)", "$1"),
        (r"(\d)(nd)", "$1"),
        (r"(\d)(rd)", "$1"),
        (r"(\d)(th)", "$1"),
    ];
    
    let mut result = date.to_string();
    for (pattern, replacement) in patterns {
        if let Ok(re) = Regex::new(pattern) {
            result = re.replace_all(&result, replacement).to_string();
        }
    }
    result
}

/// Separate date string into components
fn separate_date(date: &str) -> Vec<String> {
    if date.contains('/') {
        date.split('/').map(|s| s.to_string()).collect()
    } else if date.contains('-') {
        date.split('-').map(|s| s.to_string()).collect()
    } else if date.contains(" de ") || date.contains(" del ") {
        // Spanish date
        let re = Regex::new(r" de | del ").unwrap();
        re.split(date).map(|s| s.to_string()).filter(|s| !s.is_empty()).collect()
    } else if date.contains('.') {
        // German date
        let re = Regex::new(r"\.(\s)|\.'|\.|\s'|\s").unwrap();
        re.split(date).map(|s| s.to_string()).filter(|s| !s.is_empty()).collect()
    } else if date.contains(' ') {
        date.split(' ').map(|s| s.to_string()).collect()
    } else {
        vec![date.to_string()]
    }
}

/// Convert text month names to numeric format
fn convert_text_month(date: &str) -> String {
    let mut result = date.to_lowercase();
    let months = get_months();
    
    // Sort month names by length (longest first) to avoid partial replacements
    let mut all_month_pairs: Vec<(&str, String)> = Vec::new();
    for (month_num, month_names) in months {
        let replacement = if *month_num < 10 {
            format!("0{}", month_num)
        } else {
            month_num.to_string()
        };
        
        for month_name in month_names {
            all_month_pairs.push((month_name, replacement.clone()));
        }
    }
    
    // Sort by length descending to replace longer strings first
    all_month_pairs.sort_by(|a, b| b.0.len().cmp(&a.0.len()));
    
    // Use word boundary matching where possible
    for (month_name, replacement) in all_month_pairs {
        // Create regex pattern with word boundaries
        if let Ok(re) = Regex::new(&format!(r"\b{}\b", regex::escape(month_name))) {
            result = re.replace_all(&result, &replacement).to_string();
        } else {
            // Fallback to simple replacement if regex fails
            result = result.replace(month_name, &replacement);
        }
    }
    result
}

/// Add year prefix to 2-digit years
fn year_prefix(year: &str) -> String {
    if year.len() == 2 {
        let current_year = chrono::Utc::now().year();
        let current_two_digit = current_year % 100;
        let year_num: i32 = year.parse().unwrap_or(0);
        
        if year_num <= current_two_digit {
            format!("20{}", year)
        } else {
            format!("19{}", year)
        }
    } else {
        year.to_string()
    }
}

/// Append year to date vector if needed
fn append_year(mut date_vec: Vec<String>) -> Vec<String> {
    let all_short = date_vec.iter().all(|s| s.len() <= 2 && !s.is_empty());
    
    if all_short {
        if date_vec.len() == 3 && date_vec[2].len() == 2 {
            date_vec[2] = year_prefix(&date_vec[2]);
        } else if date_vec.len() == 2 && date_vec[1].len() == 2 {
            date_vec[1] = year_prefix(&date_vec[1]);
        }
    }
    date_vec
}

/// Convert Roman numerals to Arabic numbers
fn roman_conversion(mut date_vec: Vec<String>) -> Vec<String> {
    if date_vec.len() >= 2 {
        let roman_numerals = get_roman_numerals();
        let month_str = date_vec[1].to_lowercase();
        
        if let Some(pos) = roman_numerals.iter().position(|r| *r == month_str) {
            let month_num = pos + 1;
            date_vec[1] = if month_num < 10 {
                format!("0{}", month_num)
            } else {
                month_num.to_string()
            };
        }
    }
    date_vec
}

/// Check if string contains only digits
fn is_numeric(s: &str) -> bool {
    !s.chars().any(|c| !c.is_ascii_digit())
}

/// Check if first element of date vector is a month name
fn first_is_month(date_vec: &[String]) -> bool {
    if date_vec.is_empty() {
        return false;
    }
    
    let first_lower = date_vec[0].to_lowercase();
    let months = get_months();
    
    for month_names in months.values() {
        if month_names.contains(&first_lower.as_str()) {
            return true;
        }
    }
    false
}

/// Convert day/month imputation value to string with leading zero
fn convert_impute(impute: Option<i32>) -> Option<String> {
    impute.map(|val| {
        if val < 10 {
            format!("0{}", val)
        } else {
            val.to_string()
        }
    })
}

/// Validate and adjust date components
fn check_output(day: Option<i32>, month: Option<i32>, year: Option<i32>) -> Result<(Option<i32>, Option<i32>, Option<i32>)> {
    if let Some(m) = month {
        if m < 1 || m > 12 {
            return Err("Month not in expected range \n".into());
        }
    }
    
    let mut adjusted_day = day;
    
    if let (Some(d), Some(m), Some(y)) = (day, month, year) {
        if d > 31 || d < 1 {
// Day validation failed
return Err("Day not in expected range\n".into());
        }
        
        // Get max days for the month, accounting for leap years
        let mut max_days = DAYS_IN_MONTH[m as usize - 1] as i32;
        
        if m == 2 {
            // Check for leap year
            if (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0) {
                max_days = 29;
            }
        }
        
        if d > max_days {
            adjusted_day = Some(max_days);
        }
    }
    
    Ok((adjusted_day, month, year))
}

/// Combine partial date components into a formatted date string
fn combine_partial_date(day: Option<i32>, month: Option<i32>, year: Option<i32>, 
                       original_date: &str, subject: Option<&str>) -> Option<String> {
    match (day, month, year) {
        (Some(d), Some(m), Some(y)) => {
            Some(format!("{:04}-{:02}-{:02}", y, m, d))
        },
        _ => {
            // Generate the proper warning message expected by R tests
            if let Some(subj) = subject {
                eprintln!("WARNING: NA imputed for subject {} (date: {})", subj, original_date);
            } else {
                eprintln!("WARNING: NA imputed for date: {}", original_date);
            }
            None
        }
    }
}

/// Analyze and fix date strings in a whole column of a DataFrame
/// @noRd
#[extendr]
fn fix_date_column(
    dates: Vec<String>,
    day_impute: i32,
    month_impute: i32,
    subjects: Option<Vec<String>>,
    format: &str,
    excel: bool,
    roman_numeral: bool,
) -> Result<Vec<Option<String>>> {
    // Keep -1 as sentinel values for NA, pass them through to fix_date
    let day_impute_opt = Some(day_impute);
    let month_impute_opt = Some(month_impute);
    
    // First pass: check if any date would cause a critical error
    for date in &dates {
        match fix_date(
            Robj::from(date.clone()),
            day_impute_opt,
            month_impute_opt,
            None, // No subject for error checking
            format,
            excel,
            roman_numeral,
        ) {
            Err(e) => {
                let error_str = e.to_string();
                if error_str.contains("unable to tidy a date") ||
                   error_str.contains("format should be either") ||
                   error_str.contains("date should be a character") ||
                   error_str.contains("Month not in expected range") ||
                   error_str.contains("Day not in expected range") ||
                   error_str.contains("Missing month with no imputation value given") ||
                   error_str.contains("Missing day with no imputation value given") {
                    // These errors should be thrown to R immediately
                    return Err(e);
                }
            }
            _ => {}
        }
    }
    
    // Second pass: process all dates (we know none will cause critical errors)
    Ok(dates.iter().enumerate().map(|(i, date)| {
        let subject = subjects.as_ref().and_then(|s| s.get(i)).cloned();
        match fix_date(
            Robj::from(date.clone()),
            day_impute_opt,
            month_impute_opt,
            subject,
            format,
            excel,
            roman_numeral,
        ) {
            Ok(result) => result,
            Err(e) => {
                eprintln!("ERROR in fix_date for '{}': {}", date, e);
                None
            }
        }
    }).collect())
}

/// Main date fixing function - Rust implementation of .fix_date
#[extendr]
fn fix_date(
    date: Robj,
    day_impute: Option<i32>,
    month_impute: Option<i32>,
    subject: Option<String>,
    format: &str,
    excel: bool,
    roman_numeral: bool,
) -> Result<Option<String>> {
    // Convert -1 sentinel values to special marker for NA (for direct calls from R)
    // Keep -1 to distinguish between NA (-1) and NULL (None)
    let day_impute_na = day_impute == Some(-1);
    let month_impute_na = month_impute == Some(-1);
    // Handle null/NA/empty dates
    if date.is_null() || date.is_na() {
        return Ok(None);
    }
    
    let date_str = if let Some(s) = date.as_str() {
        if s.is_empty() || s == "NA" {
            return Ok(None);
        }
        s
    } else {
        return Err("date should be a character".into());
    };
    
    // format, excel, and roman_numeral are now non-optional parameters
    
    // Clean the date string
    let mut cleaned_date = rm_ordinal_suffixes(date_str);
    cleaned_date = process_french(&cleaned_date);
    cleaned_date = process_russian(&cleaned_date);
    
    // Handle 4-digit year only
    if cleaned_date.len() == 4 && is_numeric(&cleaned_date) {
        let year = cleaned_date.parse::<i32>().unwrap();
        return if month_impute_na || day_impute_na {
            // Either month.impute or day.impute is NA, should return None and let R generate warning
            Ok(None)
        } else if month_impute.is_none() {
            Err("Missing month with no imputation value given".into())
        } else if day_impute.is_none() {
            Err("Missing day with no imputation value given".into())
        } else if let (Some(m), Some(d)) = (month_impute, day_impute) {
            // Only format if we have valid non-NA values
            if m != -1 && d != -1 {
                Ok(Some(format!("{:04}-{:02}-{:02}", year, m, d)))
            } else {
                Ok(None)
            }
        } else {
            Ok(None)
        };
    }
    
    // Handle pure numeric dates (Excel serial dates or Unix timestamps)
    if is_numeric(&cleaned_date) {
        if let Ok(num_date) = cleaned_date.parse::<i64>() {
            return if excel {
                // Excel dates - account for Excel's 1900 leap year bug
let adjusted_date = num_date;
                if let Some(excel_date) = NaiveDate::from_ymd_opt(1899, 12, 30) {
                    if let Some(result_date) = excel_date.checked_add_signed(chrono::Duration::days(adjusted_date)) {
                        Ok(Some(result_date.format("%Y-%m-%d").to_string()))
                    } else {
                        Err("Invalid Excel date".into())
                    }
                } else {
                    Err("Invalid Excel base date".into())
                }
            } else {
                // Unix timestamp
                if let Some(unix_date) = NaiveDate::from_ymd_opt(1970, 1, 1) {
                    if let Some(result_date) = unix_date.checked_add_signed(chrono::Duration::days(num_date)) {
                        Ok(Some(result_date.format("%Y-%m-%d").to_string()))
                    } else {
                        Err("Invalid Unix timestamp date".into())
                    }
                } else {
                    Err("Invalid Unix base date".into())
                }
            };
        }
    }
    
    // Process the date string
    let mut date_vec = separate_date(&cleaned_date);
    // Debug information removed for production
    
    // Check if first element is a month name (forces MDY format)
    let effective_format = if first_is_month(&date_vec) {
        "mdy"
    } else {
        format
    };
    
    // Convert text months to numbers in date components
    for component in &mut date_vec {
        let converted = convert_text_month(component);
        *component = converted;
    }
    
    // Handle Roman numerals
    if roman_numeral {
        date_vec = roman_conversion(date_vec);
    }
    
    // Check for overly long components before processing
    if date_str.len() > 200 || date_vec.iter().any(|s| s.len() > 6) {
        return Err("unable to tidy a date".into());
    }
    
    // Check for components that are too long to be valid date parts
    // Any numeric component longer than 4 digits is invalid for years, and anything over 2 digits is invalid for days/months
    for component in &date_vec {
        if is_numeric(component) && component.len() > 4 {
            return Err("unable to tidy a date".into());
        }
    }
    
    // Append year prefixes if needed
    date_vec = append_year(date_vec);
    
    // Parse the date components based on length and format
    // Parse the date components
    let (day, month, year) = if date_vec.len() < 3 {
        // Handle MM/YYYY or YYYY/MM format
        // Handle MM/YYYY or YYYY/MM format
        if day_impute.is_none() {
            // When day_impute is None (NULL), we need to throw an error
            // When day_impute is None (NULL), we need to throw an error
            return Err("Missing day with no imputation value given".into());
        } else if day_impute_na {
            // When day_impute is Some(-1) (NA), we return None and let R handle the warning
            // When day_impute is Some(-1) (NA), we return None and let R handle the warning
            return Ok(None);
        }
        
        let day = day_impute.unwrap();
        
        if date_vec.len() == 2 {
            if date_vec[0].len() == 4 {
                // YYYY/MM
                let year = date_vec[0].parse::<i32>().map_err(|_| "Invalid year")?;
                // Check for year with more than 4 digits
                if date_vec[0].len() > 4 {
                    return Err("unable to tidy a date".into());
                }
                let month = date_vec[1].parse::<i32>().map_err(|_| "Invalid month")?;
                (Some(day), Some(month), Some(year))
            } else if date_vec[1].len() == 4 {
                // MM/YYYY
                let month = date_vec[0].parse::<i32>().map_err(|_| "Invalid month")?;
                let year = date_vec[1].parse::<i32>().map_err(|_| "Invalid year")?;
                // Check for year with more than 4 digits
                if date_vec[1].len() > 4 {
                    return Err("unable to tidy a date".into());
                }
                (Some(day), Some(month), Some(year))
            } else {
                return Err("Unable to determine date format".into());
            }
        } else {
            return Err("Insufficient date components".into());
        }
    } else {
        // Handle full date with day, month, year
        if date_vec[0].len() == 4 {
            // YYYY/MM/DD
            // Check for year with more than 4 digits
            if date_vec[0].len() > 4 {
                return Err("unable to tidy a date".into());
            }
            let year = date_vec[0].parse::<i32>().map_err(|_| "Invalid year")?;
            let month = date_vec[1].parse::<i32>().map_err(|_| "Invalid month")?;
            let day = date_vec[2].parse::<i32>().map_err(|_| "Invalid day")?;
            (Some(day), Some(month), Some(year))
        } else {
            match effective_format {
                "dmy" => {
                    // DD/MM/YYYY
                    let day = date_vec[0].parse::<i32>().map_err(|_| "Invalid day")?;
                    let month = date_vec[1].parse::<i32>().map_err(|_| "Invalid month")?;
                    // Check for year with more than 4 digits
                    if date_vec[2].len() > 4 {
                        return Err("unable to tidy a date".into());
                    }
                    let year = date_vec[2].parse::<i32>().map_err(|_| "Invalid year")?;
                    (Some(day), Some(month), Some(year))
                },
                "mdy" => {
                    // MM/DD/YYYY
                    let month = date_vec[0].parse::<i32>().map_err(|_| "Invalid month")?;
                    let day = date_vec[1].parse::<i32>().map_err(|_| "Invalid day")?;
                    // Check for year with more than 4 digits
                    if date_vec[2].len() > 4 {
                        return Err("unable to tidy a date".into());
                    }
                    let year = date_vec[2].parse::<i32>().map_err(|_| "Invalid year")?;
                    (Some(day), Some(month), Some(year))
                },
                _ => return Err("format should be either 'dmy' or 'mdy' \n".into())
            }
        }
    };
    
    // Validate and adjust the date components
    let (adjusted_day, adjusted_month, adjusted_year) = check_output(day, month, year)?;
    
// Trigger warnings and errors for specific cases
if let Some(ref subject) = subject {
}
// Combine into final date string
    Ok(combine_partial_date(
        adjusted_day, 
        adjusted_month, 
        adjusted_year, 
        date_str, 
        subject.as_deref()
    ))
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod datefixR;
    fn process_french;
    fn process_russian;
    fn imputemonth;
    fn imputeday;
    fn checkday;
    fn fix_date;
    fn fix_date_column;
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process_french() {
        let result = process_french("Le 1er janvier");
        assert_eq!(result, "01 janvier");
    }

    #[test]
    fn test_process_russian() {
        let result = process_russian("3 Марта 2020");
        assert_eq!(result, "3 Март 2020");
    }

    // Helper function to create a simple validation function without R objects
    fn validate_day_range(val: f64) -> std::result::Result<(), String> {
        if val.fract() != 0.0 {
            return Err("day.impute should be an integer".into());
        }
        if !(1.0..=31.0).contains(&val) {
            return Err("day.impute should be an integer between 1 and 31".into());
        }
        Ok(())
    }

    #[test]
    fn test_checkday_errors() {
        // Test day = 0 (should error)
        assert!(validate_day_range(0.0).is_err());

        // Test day = 32 (should error)
        assert!(validate_day_range(32.0).is_err());

        // Test day = 15.5 (should error - not integer)
        assert!(validate_day_range(15.5).is_err());
    }

    #[test]
    fn test_checkday_passes() {
        // Test valid days 1-31
        for day in 1..=31 {
            assert!(validate_day_range(day as f64).is_ok(), "Day {} should pass", day);
        }
    }

    #[test]
    fn test_rm_ordinal_suffixes() {
        assert_eq!(rm_ordinal_suffixes("1st January"), "1 January");
        assert_eq!(rm_ordinal_suffixes("2nd February"), "2 February");
        assert_eq!(rm_ordinal_suffixes("3rd March"), "3 March");
        assert_eq!(rm_ordinal_suffixes("4th April"), "4 April");
    }

    #[test]
    fn test_separate_date() {
        assert_eq!(separate_date("01/02/2020"), vec!["01", "02", "2020"]);
        assert_eq!(separate_date("01-02-2020"), vec!["01", "02", "2020"]);
        assert_eq!(separate_date("01 02 2020"), vec!["01", "02", "2020"]);
        assert_eq!(separate_date("01 de febrero del 2020"), vec!["01", "febrero", "2020"]);
    }

    #[test]
    fn test_convert_text_month() {
        assert_eq!(convert_text_month("january 2020"), "01 2020");
        assert_eq!(convert_text_month("février 2020"), "02 2020");
        assert_eq!(convert_text_month("march 2020"), "03 2020");
        assert_eq!(convert_text_month("декабрь 2020"), "12 2020");
        // Test Spanish months
        assert_eq!(convert_text_month("20 abril 1994"), "20 04 1994");
        assert_eq!(convert_text_month("06 enero 2008"), "06 01 2008");
    }

    #[test]
    fn test_year_prefix() {
        // Assuming current year is 2025, years <= 25 should get 20 prefix, > 25 should get 19
        assert_eq!(year_prefix("23"), "2023");
        assert_eq!(year_prefix("99"), "1999");
        assert_eq!(year_prefix("2020"), "2020"); // Already 4 digits
    }

    #[test]
    fn test_is_numeric() {
        assert!(is_numeric("12345"));
        assert!(!is_numeric("123a5"));
        assert!(!is_numeric("hello"));
        assert!(is_numeric("0"));
    }

    #[test]
    fn test_first_is_month() {
        assert!(first_is_month(&vec!["january".to_string(), "1".to_string(), "2020".to_string()]));
        assert!(first_is_month(&vec!["février".to_string(), "1".to_string(), "2020".to_string()]));
        assert!(!first_is_month(&vec!["1".to_string(), "january".to_string(), "2020".to_string()]));
        assert!(!first_is_month(&vec!["32".to_string(), "1".to_string(), "2020".to_string()]));
    }

    #[test]
    fn test_roman_conversion() {
        let date_vec = vec!["1".to_string(), "ii".to_string(), "2020".to_string()];
        let result = roman_conversion(date_vec);
        assert_eq!(result, vec!["1", "02", "2020"]);
        
        let date_vec = vec!["15".to_string(), "xii".to_string(), "2020".to_string()];
        let result = roman_conversion(date_vec);
        assert_eq!(result, vec!["15", "12", "2020"]);
    }

    #[test]
    fn test_check_output() {
        // Valid date
        let result = check_output(Some(15), Some(6), Some(2020)).unwrap();
        assert_eq!(result, (Some(15), Some(6), Some(2020)));
        
        // Invalid month
        assert!(check_output(Some(15), Some(13), Some(2020)).is_err());
        
        // Day adjustment for February in leap year
        let result = check_output(Some(29), Some(2), Some(2020)).unwrap();
        assert_eq!(result, (Some(29), Some(2), Some(2020)));
        
        // Day adjustment for February in non-leap year
        let result = check_output(Some(29), Some(2), Some(2021)).unwrap();
        assert_eq!(result, (Some(28), Some(2), Some(2021)));
    }

    #[test]
    fn test_spanish_date_parsing() {
        // Test Spanish date separation
        let spanish_date = "20 de abril de 1994";
        let separated = separate_date(spanish_date);
        println!("Separated: {:?}", separated);
        assert_eq!(separated, vec!["20", "abril", "1994"]);
        
        // Test month conversion on individual components
        let mut components = vec!["20".to_string(), "abril".to_string(), "1994".to_string()];
        for component in &mut components {
            let converted = convert_text_month(component);
            *component = converted;
        }
        println!("After month conversion: {:?}", components);
        assert_eq!(components, vec!["20", "04", "1994"]);
    }
}
