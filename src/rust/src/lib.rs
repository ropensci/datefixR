#![allow(non_snake_case)]
use chrono::{Datelike, NaiveDate};
use extendr_api::prelude::*;
use std::collections::HashMap;
use std::sync::OnceLock;

mod translations;
use translations::*;
mod optimizations;
use optimizations::*;

/// Month names in different languages (mirroring R months data)
static MONTHS: OnceLock<HashMap<usize, Vec<&'static str>>> = OnceLock::new();
static ROMAN_NUMERALS: OnceLock<Vec<&'static str>> = OnceLock::new();
static DAYS_IN_MONTH: [u8; 12] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
static CURRENT_YEAR: OnceLock<i32> = OnceLock::new();

/// Get cached current year to avoid repeated system calls
#[inline]
fn get_current_year() -> i32 {
    *CURRENT_YEAR.get_or_init(|| chrono::Utc::now().year())
}


fn get_months() -> &'static HashMap<usize, Vec<&'static str>> {
    MONTHS.get_or_init(|| {
        let mut months = HashMap::new();
        months.insert(
            1,
            vec![
                "january",
                "janvier",
                "janeiro",
                "janv",
                "januar",
                "jänner",
                "jän",
                "enero",
                "ener",
                "ene",
                "jan",
                "январь",
                "января",
                "янв",
                "januari",
            ],
        );
        months.insert(
            2,
            vec![
                "february",
                "février",
                "fevrier",
                "fevereiro",
                "févr",
                "fevr",
                "fev",
                "februar",
                "febrero",
                "feb",
                "февраль",
                "февраля",
                "фев",
                "februari",
            ],
        );
        months.insert(
            3,
            vec![
                "march", "mars", "märz", "marzo", "março", "marco", "marz", "mar", "март", "мар",
                "maret",
            ],
        );
        months.insert(
            4,
            vec![
                "april",
                "avril",
                "abril",
                "abr",
                "apr",
                "апрель",
                "апреля",
                "апр",
            ],
        );
        months.insert(5, vec!["mayo", "may", "maio", "mai", "май", "мая", "mei"]);
        months.insert(
            6,
            vec![
                "june", "juin", "junio", "junho", "juni", "jun", "июнь", "июня", "июн",
            ],
        );
        months.insert(
            7,
            vec![
                "july", "juillet", "juil", "julio", "julho", "juli", "jul", "июль", "июля", "июл",
            ],
        );
        months.insert(
            8,
            vec![
                "august",
                "aug",
                "août",
                "aout",
                "agosto",
                "август",
                "авг",
                "agustus",
            ],
        );
        months.insert(
            9,
            vec![
                "september",
                "septembre",
                "septiembre",
                "setembro",
                "set",
                "sept",
                "sep",
                "сентябрь",
                "сентября",
                "сент",
            ],
        );
        months.insert(
            10,
            vec![
                "october",
                "octobre",
                "oktober",
                "okt",
                "octubre",
                "outubro",
                "oct",
                "out",
                "октябрь",
                "октября",
                "окт",
            ],
        );
        months.insert(
            11,
            vec![
                "november",
                "novembre",
                "noviembre",
                "novembro",
                "nov",
                "ноябрь",
                "ноября",
                "ноя",
            ],
        );
        months.insert(
            12,
            vec![
                "december",
                "décembre",
                "decembre",
                "déc",
                "dezember",
                "dezembro",
                "dez",
                "diciembre",
                "dic",
                "dec",
                "декабрь",
                "декабря",
                "дек",
                "desember",
            ],
        );
        months
    })
}

fn get_roman_numerals() -> &'static Vec<&'static str> {
    ROMAN_NUMERALS.get_or_init(|| {
        vec![
            "i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x", "xi", "xii",
        ]
    })
}

/// Private helper function to replace multiple patterns in a string

/// Get pre-compiled ordinal regexes

/// Remove ordinal suffixes from date strings (optimized with pre-compiled regexes)

/// Separate date string into components

/// Get pre-compiled month regexes

/// Convert text month names to numeric format (optimized with pre-compiled regexes)

/// Add year prefix to 2-digit years
#[inline]
fn year_prefix(year: &str) -> String {
    if year.len() == 2 {
        let current_year = get_current_year();
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
#[inline]
fn is_numeric(s: &str) -> bool {
    !s.chars().any(|c| !c.is_ascii_digit())
}

/// Helper function to clean numeric strings by removing trailing punctuation
#[inline]
fn clean_numeric_string(s: &str) -> &str {
    s.trim_end_matches(|c: char| !c.is_ascii_digit())
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

/// Validate day imputation value range
/// @noRd
#[extendr]
fn checkday(day_impute: Robj) -> Result<()> {
    if day_impute.is_null() || day_impute.len() == 0 {
        return Ok(()); // nothing to check
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
        }
        Rtype::Integers => {
            let int_val = day_impute.as_integer().unwrap_or(i32::MIN);
            if int_val == i32::MIN {
                return Ok(()); // NA values are OK
            }
            int_val as f64
        }
        _ => return Err("day.impute must be numeric".into()),
    };

    if val.fract() != 0.0 {
        return Err(day_impute_integer().into());
    }
    if !(1.0..=31.0).contains(&val) {
        return Err(day_impute_integer_range().into());
    }
    Ok(())
}

/// Validate and adjust date components
fn check_output(
    day: Option<i32>,
    month: Option<i32>,
    year: Option<i32>,
) -> Result<(Option<i32>, Option<i32>, Option<i32>)> {
    if let Some(m) = month {
        if m < 1 || m > 12 {
return Err(format!("{}\n", month_not_in_range()).into());
        }
    }

    let mut adjusted_day = day;

    if let (Some(d), Some(m), Some(y)) = (day, month, year) {
        if d > 31 || d < 1 {
            // Day validation failed
            return Err(day_not_in_range().into());
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
fn combine_partial_date(
    day: Option<i32>,
    month: Option<i32>,
    year: Option<i32>,
    original_date: &str,
    subject: Option<&str>,
) -> Option<String> {
    match (day, month, year) {
        (Some(d), Some(m), Some(y)) => Some(format!("{:04}-{:02}-{:02}", y, m, d)),
        _ => {
            // Generate the proper warning message expected by R tests
            if let Some(subj) = subject {
                eprintln!(
                    "WARNING: {} {} {} {} {}",
                    na_imputed_for_subject(),
                    subj,
                    date_open_paren(),
                    original_date,
                    close_paren()
                );
            } else {
                eprintln!("WARNING: {} {}", na_imputed_date(), original_date);
            }
            None
        }
    }
}

/// Handle 4-digit year only dates (e.g., "2020")
fn handle_year_only_date(
    cleaned_date: &str,
    day_impute: Option<i32>,
    month_impute: Option<i32>,
    day_impute_na: bool,
    month_impute_na: bool,
) -> Result<Option<String>> {
    if cleaned_date.len() == 4 && is_numeric(cleaned_date) {
        let year = cleaned_date.parse::<i32>().unwrap();
        return if month_impute_na || day_impute_na {
            // Either month.impute or day.impute is NA, should return None and let R generate warning
            Ok(None)
        } else if month_impute.is_none() {
            Err(missing_month_no_imputation().into())
        } else if day_impute.is_none() {
            Err(missing_day_no_imputation().into())
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
    // Not a year-only date, continue with other parsing
    Ok(None)
}

/// Handle pure numeric dates (Excel serial dates or Unix timestamps)
fn handle_numeric_dates(
    cleaned_date: &str,
    excel: bool,
) -> Result<Option<String>> {
    // Exclude 4-digit numbers as they're more likely to be years than timestamps
    if is_numeric(cleaned_date) && cleaned_date.len() != 4 {
        if let Ok(num_date) = cleaned_date.parse::<i64>() {
            return if excel {
                // Excel dates - account for Excel's 1900 leap year bug
                let adjusted_date = num_date;
                if let Some(excel_date) = NaiveDate::from_ymd_opt(1899, 12, 30) {
                    if let Some(result_date) =
                        excel_date.checked_add_signed(chrono::Duration::days(adjusted_date))
                    {
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
                    if let Some(result_date) =
                        unix_date.checked_add_signed(chrono::Duration::days(num_date))
                    {
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
    // Not a pure numeric date, continue with other parsing
    Ok(None)
}


/// Process a single date with error handling for batch operations
fn process_single_date_with_error_handling(
    date: &str,
    day_impute: Option<i32>,
    month_impute: Option<i32>,
    subject: Option<&str>,
    format: &str,
    excel: bool,
    roman_numeral: bool,
) -> Result<Option<String>> {
    match fix_date_native(
        date,
        day_impute,
        month_impute,
        subject,
        format,
        excel,
        roman_numeral,
    ) {
        Ok(result) => Ok(result),
        Err(e) => {
            let error_str = e.to_string();
            if error_str.contains("unable to tidy a date")
                || error_str.contains("format should be either")
                || error_str.contains("date should be a character")
                || error_str.contains("Month not in expected range\n")
                || error_str.contains("Day not in expected range")
                || error_str.contains("Missing month with no imputation value given")
                || error_str.contains("Missing day with no imputation value given")
            {
                Err(e)
            } else {
                // For other errors, return None instead of propagating
                Ok(None)
            }
        }
    }
}

/// Parse date components from date vector based on length and format
fn parse_date_components(
    date_vec: &[String],
    effective_format: &str,
    day_impute: Option<i32>,
    day_impute_na: bool,
) -> Result<(Option<i32>, Option<i32>, Option<i32>)> {
    if date_vec.len() < 3 {
        // Handle MM/YYYY or YYYY/MM format
        if day_impute.is_none() {
            // When day_impute is None (NULL), we need to throw an error
            return Err(missing_day_no_imputation().into());
        } else if day_impute_na {
            // When day_impute is Some(-1) (NA), we return None and let R handle the warning
            return Err("NA imputation requested".into()); // Special error to signal NA return
        }

        let day = day_impute.unwrap();

        if date_vec.len() == 2 {
            if date_vec[0].len() == 4 {
                // YYYY/MM
                validate_year_length(&date_vec[0])?;
                let year = date_vec[0].parse::<i32>().map_err(|_| "Invalid year")?;
                let month = date_vec[1].parse::<i32>().map_err(|_| "Invalid month")?;
                Ok((Some(day), Some(month), Some(year)))
            } else if date_vec[1].len() == 4 {
                // MM/YYYY
                validate_year_length(&date_vec[1])?;
                let month = date_vec[0].parse::<i32>().map_err(|_| "Invalid month")?;
                let year = date_vec[1].parse::<i32>().map_err(|_| "Invalid year")?;
                Ok((Some(day), Some(month), Some(year)))
            } else {
                Err("Unable to determine date format".into())
            }
        } else {
            Err("Insufficient date components".into())
        }
    } else {
        // Handle full date with day, month, year
        if date_vec[0].len() == 4 {
            // YYYY/MM/DD
            validate_year_length(&date_vec[0])?;
            let year = date_vec[0].parse::<i32>().map_err(|_| "Invalid year")?;
            let month = date_vec[1].parse::<i32>().map_err(|_| "Invalid month")?;
            let day = date_vec[2].parse::<i32>().map_err(|_| "Invalid day")?;
            Ok((Some(day), Some(month), Some(year)))
        } else {
            match effective_format {
                "dmy" => {
                    // DD/MM/YYYY
                    let day = date_vec[0].parse::<i32>().map_err(|_| "Invalid day")?;
                    let month = date_vec[1].parse::<i32>().map_err(|_| "Invalid month")?;
                    validate_year_length(&date_vec[2])?;
                    let year = date_vec[2].parse::<i32>().map_err(|_| "Invalid year")?;
                    Ok((Some(day), Some(month), Some(year)))
                }
                "mdy" => {
                    // MM/DD/YYYY
                    let month = date_vec[0].parse::<i32>().map_err(|_| "Invalid month")?;
                    let day_str = clean_numeric_string(&date_vec[1]);
                    let day = day_str.parse::<i32>().map_err(|_| "Invalid day")?;
                    validate_year_length(&date_vec[2])?;
                    let year = date_vec[2].parse::<i32>().map_err(|_| "Invalid year")?;
                    Ok((Some(day), Some(month), Some(year)))
                }
                _ => Err(format_should_be_dmy_or_mdy().into()),
            }
        }
    }
}

/// Helper function to validate year string length
#[inline]
fn validate_year_length(year_str: &str) -> Result<()> {
    if year_str.len() > 4 {
        Err(unable_to_tidy_date().into())
    } else {
        Ok(())
    }
}

/// Common date processing pipeline used by both fix_date and fix_date_native
fn process_date_pipeline(
    date_str: &str,
    day_impute: Option<i32>,
    month_impute: Option<i32>, 
    subject: Option<&str>,
    format: &str,
    excel: bool,
    roman_numeral: bool,
) -> Result<Option<String>> {
    // Convert -1 sentinel values to special marker for NA (for direct calls from R)
    // Keep -1 to distinguish between NA (-1) and NULL (None)
    let day_impute_na = day_impute == Some(-1);
    let month_impute_na = month_impute == Some(-1);
    
    // Handle null/NA/empty dates
    if date_str.is_empty() || date_str == "NA" {
        return Ok(None);
    }

    // Try fast-path parsing for common formats first
    if let Some((day, month, year)) = fast_path_parse_date(date_str, format) {
        // Still need to validate and adjust the date components (e.g., Feb 30 -> Feb 28)
        let (adjusted_day, adjusted_month, adjusted_year) = check_output(
            Some(day as i32),
            Some(month as i32),
            Some(year as i32),
        )?;
        
        return Ok(combine_partial_date(
            adjusted_day,
            adjusted_month,
            adjusted_year,
            date_str,
            subject,
        ));
    }

    // Clean the date string using combined approach
    let cleaned_date = clean_date_string_combined(date_str).into_owned();

    // Try handling as year-only date
    match handle_year_only_date(&cleaned_date, day_impute, month_impute, day_impute_na, month_impute_na) {
        Ok(Some(result)) => return Ok(Some(result)),
        Ok(None) => {
            // Year-only date was handled but resulted in None (NA imputation case)
            // Check if this was actually a year-only date that should return None
            if cleaned_date.len() == 4 && is_numeric(&cleaned_date) {
                return Ok(None);
            }
            // Otherwise, continue with normal processing
        }
        Err(_) => {
            // Not a year-only date or error occurred, continue with normal processing
        }
    }

    // Try handling as pure numeric date (Excel/Unix)
    if let Ok(Some(result)) = handle_numeric_dates(&cleaned_date, excel) {
        return Ok(Some(result));
    }

    // Process the date string - convert to Vec<String> from Vec<&str>
    let date_vec_str = separate_date_optimized(&cleaned_date);
    let mut date_vec: Vec<String> = date_vec_str.into_iter().map(|s| s.to_string()).collect();
    // Debug information removed for production

    // Check if first element is a month name (forces MDY format)
    let effective_format = if first_is_month(&date_vec) {
        "mdy"
    } else {
        format
    };

    // Convert text months to numbers in date components
    for component in &mut date_vec {
        let converted = convert_text_month_optimized(component).into_owned();
        *component = converted;
    }

    // Handle Roman numerals
    if roman_numeral {
        date_vec = roman_conversion(date_vec);
    }

    // Check for overly long components before processing
    if date_str.len() > 200 || date_vec.iter().any(|s| s.len() > 6) {
        return Err(unable_to_tidy_date().into());
    }

    // Check for components that are too long to be valid date parts
    // Any numeric component longer than 4 digits is invalid for years, and anything over 2 digits is invalid for days/months
    for component in &date_vec {
        if is_numeric(component) && component.len() > 4 {
            return Err(unable_to_tidy_date().into());
        }
    }

    // Append year prefixes if needed
    date_vec = append_year(date_vec);

    // Parse the date components based on length and format
    let (day, month, year) = match parse_date_components(&date_vec, &effective_format, day_impute, day_impute_na) {
        Ok(components) => components,
        Err(e) => {
            if e.to_string().contains("NA imputation requested") {
                return Ok(None);
            }
            return Err(e);
        }
    };

    // Validate and adjust the date components
    let (adjusted_day, adjusted_month, adjusted_year) = check_output(day, month, year)?;

    // Combine into final date string
    Ok(combine_partial_date(
        adjusted_day,
        adjusted_month,
        adjusted_year,
        date_str,
        subject,
    ))
}

/// Internal native function to fix a single date string efficiently
fn fix_date_native(
    date_str: &str,
    day_impute: Option<i32>,
    month_impute: Option<i32>,
    subject: Option<&str>,
    format: &str,
    excel: bool,
    roman_numeral: bool,
) -> Result<Option<String>> {
    process_date_pipeline(date_str, day_impute, month_impute, subject, format, excel, roman_numeral)
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
    // Process all dates using native Rust function to avoid R object conversions
    let day_impute_opt = Some(day_impute);
    let month_impute_opt = Some(month_impute);

    dates.into_iter().enumerate().map(|(i, date)| {
        let subject = subjects.as_ref().and_then(|s| s.get(i));
        
        // Use helper function for cleaner error handling
        process_single_date_with_error_handling(
            &date,
            day_impute_opt,
            month_impute_opt,
            subject.map(|s| s.as_str()),
            format,
            excel,
            roman_numeral,
        )
    }).collect::<Result<Vec<Option<String>>>>()
}

/// Main date fixing function - Rust implementation of .fix_date
/// @noRd
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
    // Handle null/NA/empty dates at R object level
    if date.is_null() || date.is_na() {
        return Ok(None);
    }

    let date_str = if let Some(s) = date.as_str() {
        if s.is_empty() || s == "NA" {
            return Ok(None);
        }
        s
    } else {
        return Err(date_should_be_character().into());
    };

    // Use the common processing pipeline
    process_date_pipeline(
        date_str, 
        day_impute, 
        month_impute, 
        subject.as_deref(), 
        format, 
        excel, 
        roman_numeral
    )
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod datefixR;
    fn checkday;
    fn fix_date;
    fn fix_date_column;
}

#[cfg(test)]
mod tests {
    use super::*;

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
            assert!(
                validate_day_range(day as f64).is_ok(),
                "Day {} should pass",
                day
            );
        }
    }

    #[test]
    fn test_rm_ordinal_suffixes() {
        assert_eq!(rm_ordinal_suffixes_optimized("1st January"), "1 January");
        assert_eq!(rm_ordinal_suffixes_optimized("2nd February"), "2 February");
        assert_eq!(rm_ordinal_suffixes_optimized("3rd March"), "3 March");
        assert_eq!(rm_ordinal_suffixes_optimized("4th April"), "4 April");
    }

    #[test]
    fn test_separate_date() {
        assert_eq!(separate_date_optimized("01/02/2020"), vec!["01", "02", "2020"]);
        assert_eq!(separate_date_optimized("01-02-2020"), vec!["01", "02", "2020"]);
        assert_eq!(separate_date_optimized("01 02 2020"), vec!["01", "02", "2020"]);
        assert_eq!(
            separate_date_optimized("01 de febrero del 2020"),
            vec!["01", "febrero", "2020"]
        );
    }

    #[test]
    fn test_convert_text_month() {
        assert_eq!(convert_text_month_optimized("january 2020"), "01 2020");
        assert_eq!(convert_text_month_optimized("février 2020"), "02 2020");
        assert_eq!(convert_text_month_optimized("march 2020"), "03 2020");
        assert_eq!(convert_text_month_optimized("декабрь 2020"), "12 2020");
        // Test Spanish months
        assert_eq!(convert_text_month_optimized("20 abril 1994"), "20 04 1994");
        assert_eq!(convert_text_month_optimized("06 enero 2008"), "06 01 2008");
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
        assert!(first_is_month(&vec![
            "january".to_string(),
            "1".to_string(),
            "2020".to_string()
        ]));
        assert!(first_is_month(&vec![
            "février".to_string(),
            "1".to_string(),
            "2020".to_string()
        ]));
        assert!(!first_is_month(&vec![
            "1".to_string(),
            "january".to_string(),
            "2020".to_string()
        ]));
        assert!(!first_is_month(&vec![
            "32".to_string(),
            "1".to_string(),
            "2020".to_string()
        ]));
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
        let separated = separate_date_optimized(spanish_date);
        println!("Separated: {:?}", separated);
        assert_eq!(separated, vec!["20", "abril", "1994"]);

        // Test month conversion on individual components
        let mut components = vec!["20".to_string(), "abril".to_string(), "1994".to_string()];
        for component in &mut components {
            let converted = convert_text_month_optimized(component).into_owned();
            *component = converted;
        }
        println!("After month conversion: {:?}", components);
        assert_eq!(components, vec!["20", "04", "1994"]);
    }

    #[test]
    fn test_handle_year_only_date() {
        // Test valid year-only date with imputation
        let result = handle_year_only_date("2020", Some(15), Some(6), false, false).unwrap();
        assert_eq!(result, Some("2020-06-15".to_string()));

        // Test year-only date with NA day imputation
        let result = handle_year_only_date("2020", Some(-1), Some(6), true, false).unwrap();
        assert_eq!(result, None);

        // Test year-only date with NA month imputation
        let result = handle_year_only_date("2020", Some(15), Some(-1), false, true).unwrap();
        assert_eq!(result, None);

        // Test year-only date with both NA imputation values
        let result = handle_year_only_date("2020", Some(-1), Some(-1), true, true).unwrap();
        assert_eq!(result, None);

        // Test year-only date with missing month imputation (should error)
        let result = handle_year_only_date("2020", Some(15), None, false, false);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("Missing month"));

        // Test year-only date with missing day imputation (should error)
        let result = handle_year_only_date("2020", None, Some(6), false, false);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("Missing day"));

        // Test non-year-only date (should return None to continue processing)
        let result = handle_year_only_date("01/02/2020", Some(15), Some(6), false, false).unwrap();
        assert_eq!(result, None);

        // Test non-numeric year-only (should return None to continue processing)
        let result = handle_year_only_date("abcd", Some(15), Some(6), false, false).unwrap();
        assert_eq!(result, None);

        // Test 3-digit year (should return None to continue processing)
        let result = handle_year_only_date("202", Some(15), Some(6), false, false).unwrap();
        assert_eq!(result, None);

        // Test 5-digit year (should return None to continue processing)
        let result = handle_year_only_date("20201", Some(15), Some(6), false, false).unwrap();
        assert_eq!(result, None);

        // Test edge case: year 0000
        let result = handle_year_only_date("0000", Some(1), Some(1), false, false).unwrap();
        assert_eq!(result, Some("0000-01-01".to_string()));

        // Test edge case: year 9999
        let result = handle_year_only_date("9999", Some(31), Some(12), false, false).unwrap();
        assert_eq!(result, Some("9999-12-31".to_string()));
    }

    #[test]
    fn test_process_date_pipeline_na_imputation() {
        // Test year-only date with NA month imputation
        let result = process_date_pipeline(
            "1994",
            Some(1),      // day_impute = 1
            Some(-1),     // month_impute = -1 (NA)
            Some("1"),    // subject
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, None); // Should return None for NA imputation

        // Test year-only date with NA day imputation
        let result = process_date_pipeline(
            "1994",
            Some(-1),     // day_impute = -1 (NA)
            Some(7),      // month_impute = 7
            Some("1"),    // subject
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, None); // Should return None for NA imputation

        // Test year-only date with both NA imputation values
        let result = process_date_pipeline(
            "1994",
            Some(-1),     // day_impute = -1 (NA)
            Some(-1),     // month_impute = -1 (NA)
            Some("1"),    // subject
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, None); // Should return None for NA imputation

        // Test MM/YYYY format with NA day imputation
        let result = process_date_pipeline(
            "04/1994",
            Some(-1),     // day_impute = -1 (NA)
            Some(7),      // month_impute = 7
            Some("1"),    // subject
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, None); // Should return None for NA imputation
    }

    #[test]
    fn test_handle_numeric_dates() {
        // Test Excel date parsing
        let result = handle_numeric_dates("44927", true).unwrap();
        assert!(result.is_some());
        let date_str = result.unwrap();
        // Excel date 44927 should be around 2023 (give or take depending on Excel's epoch)
        assert!(date_str.starts_with("202"));

        // Test Unix timestamp parsing
        let result = handle_numeric_dates("18628", false).unwrap();
        assert!(result.is_some());
        let date_str = result.unwrap();
        // Unix day 18628 from 1970-01-01 should be around 2021
        assert!(date_str.starts_with("202"));

        // Test small Excel date
        let result = handle_numeric_dates("1", true).unwrap();
        assert!(result.is_some());
        let date_str = result.unwrap();
        assert_eq!(date_str, "1899-12-31"); // Excel day 1 = Dec 31, 1899

        // Test small Unix date
        let result = handle_numeric_dates("1", false).unwrap();
        assert!(result.is_some());
        let date_str = result.unwrap();
        assert_eq!(date_str, "1970-01-02"); // Unix day 1 = Jan 2, 1970

        // Test zero for both systems
        let excel_zero = handle_numeric_dates("0", true).unwrap();
        assert!(excel_zero.is_some());
        let unix_zero = handle_numeric_dates("0", false).unwrap();
        assert!(unix_zero.is_some());
        // Excel day 0 vs Unix day 0 should be different
        assert_ne!(excel_zero.unwrap(), unix_zero.unwrap());

        // Test non-numeric input (should return None to continue processing)
        let result = handle_numeric_dates("01/02/2020", true).unwrap();
        assert_eq!(result, None);

        // Test non-numeric input with letters
        let result = handle_numeric_dates("abc123", true).unwrap();
        assert_eq!(result, None);

        // Test empty string
        let result = handle_numeric_dates("", true).unwrap();
        assert_eq!(result, None);

        // Test mixed alphanumeric
        let result = handle_numeric_dates("123abc", true).unwrap();
        assert_eq!(result, None);

        // Test with spaces
        let result = handle_numeric_dates("123 456", true).unwrap();
        assert_eq!(result, None);

        // Test very large number that might overflow
        let result = handle_numeric_dates("999999999999999999999999999999999", true);
        // This should either return None (parsing fails) or handle gracefully
        assert!(result.is_ok());
        if let Ok(Some(_)) = result {
            // If it parses, that's fine
        } else {
            // If it doesn't parse or returns None, that's also fine
            assert!(true);
        }

        // Test negative numbers (should handle gracefully)
        let result = handle_numeric_dates("-100", true);
        assert!(result.is_ok()); // Should not panic, might return error or None
    }

    #[test]
    fn test_parse_date_components() {
        // Test DMY format (DD/MM/YYYY)
        let date_vec = vec!["15".to_string(), "06".to_string(), "2020".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(1), false).unwrap();
        assert_eq!(result, (Some(15), Some(6), Some(2020)));

        // Test MDY format (MM/DD/YYYY)
        let date_vec = vec!["06".to_string(), "15".to_string(), "2020".to_string()];
        let result = parse_date_components(&date_vec, "mdy", Some(1), false).unwrap();
        assert_eq!(result, (Some(15), Some(6), Some(2020)));

        // Test YMD format (YYYY/MM/DD)
        let date_vec = vec!["2020".to_string(), "06".to_string(), "15".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(1), false).unwrap();
        assert_eq!(result, (Some(15), Some(6), Some(2020)));

        // Test MM/YYYY format with day imputation
        let date_vec = vec!["06".to_string(), "2020".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(15), false).unwrap();
        assert_eq!(result, (Some(15), Some(6), Some(2020)));

        // Test YYYY/MM format with day imputation
        let date_vec = vec!["2020".to_string(), "06".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(15), false).unwrap();
        assert_eq!(result, (Some(15), Some(6), Some(2020)));

        // Test insufficient components (single element) - should error
        let date_vec = vec!["2020".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(15), false);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("Insufficient"));

        // Test missing day imputation (None) - should error
        let date_vec = vec!["06".to_string(), "2020".to_string()];
        let result = parse_date_components(&date_vec, "dmy", None, false);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("Missing day"));

        // Test NA day imputation - should return special error
        let date_vec = vec!["06".to_string(), "2020".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(-1), true);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("NA imputation requested"));

        // Test invalid format
        let date_vec = vec!["15".to_string(), "06".to_string(), "2020".to_string()];
        let result = parse_date_components(&date_vec, "xyz", Some(1), false);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("format should be either"));

        // Test overly long year (more than 4 digits) - should error
        let date_vec = vec!["15".to_string(), "06".to_string(), "20201".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(1), false);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("unable to tidy"));

        // Test invalid numeric components
        let date_vec = vec!["abc".to_string(), "06".to_string(), "2020".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(1), false);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("Invalid"));

        // Test ambiguous 2-component format (neither is 4 digits)
        let date_vec = vec!["06".to_string(), "15".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(1), false);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("Unable to determine"));

        // Test MDY with day having trailing punctuation (should be cleaned)
        let date_vec = vec!["06".to_string(), "15,".to_string(), "2020".to_string()];
        let result = parse_date_components(&date_vec, "mdy", Some(1), false).unwrap();
        assert_eq!(result, (Some(15), Some(6), Some(2020)));

        // Test edge cases: year 0000
        let date_vec = vec!["0000".to_string(), "01".to_string(), "01".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(1), false).unwrap();
        assert_eq!(result, (Some(1), Some(1), Some(0)));

        // Test edge cases: year 9999
        let date_vec = vec!["31".to_string(), "12".to_string(), "9999".to_string()];
        let result = parse_date_components(&date_vec, "dmy", Some(1), false).unwrap();
        assert_eq!(result, (Some(31), Some(12), Some(9999)));
    }

    #[test]
    fn test_process_single_date_with_error_handling() {
        // Test successful date processing
        let result = process_single_date_with_error_handling(
            "15/06/2020",
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, Some("2020-06-15".to_string()));

        // Test with subject
        let result = process_single_date_with_error_handling(
            "06/15/2020",
            Some(1),
            Some(1),
            Some("test_subject"),
            "mdy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, Some("2020-06-15".to_string()));

        // Test critical errors that should be propagated - invalid format
        // Use a date that won't be caught by fast-path parser to test format validation
        let result = process_single_date_with_error_handling(
            "15 06 2020", // Space-separated date that bypasses fast-path
            Some(1),
            Some(1),
            None,
            "xyz", // Invalid format
            false,
            false,
        );
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("format should be either"));

        // Test critical errors that should be propagated - missing day imputation
        let result = process_single_date_with_error_handling(
            "06 2020", // 2-component space-separated date requiring day imputation
            None, // No day imputation provided
            Some(1),
            None,
            "dmy",
            false,
            false,
        );
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("Missing day"));

        // Test critical errors that should be propagated - month out of range
        let result = process_single_date_with_error_handling(
            "15 13 2020", // Month 13 is invalid, space-separated
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        );
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("Month not in expected range"));

        // Test critical errors that should be propagated - day out of range
        let result = process_single_date_with_error_handling(
            "32 06 2020", // Day 32 is invalid, space-separated
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        );
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("Day not in expected range"));

        // Test critical errors that should be propagated - unable to tidy date
        let result = process_single_date_with_error_handling(
            "15 06 202001", // Year too long, space-separated
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        );
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("unable to tidy a date"));

        // Test empty date string (should return None, not error)
        let result = process_single_date_with_error_handling(
            "",
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, None);

        // Test NA date string (should return None, not error)
        let result = process_single_date_with_error_handling(
            "NA",
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, None);

        // Test partial date with imputation (MM/YYYY)
        let result = process_single_date_with_error_handling(
            "06/2020",
            Some(25), // Day imputation
            Some(1),
            None,
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, Some("2020-06-25".to_string()));

        // Test date adjustment (Feb 30 -> Feb 28)
        let result = process_single_date_with_error_handling(
            "30/02/2021", // Feb 30 in non-leap year
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, Some("2021-02-28".to_string())); // Should be adjusted to Feb 28

        // Test date adjustment (Feb 29 in leap year - should be preserved)
        let result = process_single_date_with_error_handling(
            "29/02/2020", // Feb 29 in leap year
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, Some("2020-02-29".to_string())); // Should be preserved

        // Test with 2-digit year conversion
        let result = process_single_date_with_error_handling(
            "15/06/99", // 99 should become 1999
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, Some("1999-06-15".to_string()));

        // Test Roman numeral conversion
        let result = process_single_date_with_error_handling(
            "15/xii/2020", // December in Roman numerals
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            true, // Roman numeral mode
        ).unwrap();
        assert_eq!(result, Some("2020-12-15".to_string()));

        // Test date with month name (forces MDY)
        let result = process_single_date_with_error_handling(
            "january 15 2020",
            Some(1),
            Some(1),
            None,
            "dmy", // Should be overridden to mdy due to month name
            false,
            false,
        ).unwrap();
        assert_eq!(result, Some("2020-01-15".to_string()));
    }

    #[test]
    fn test_process_single_date_error_propagation() {
        // Test that critical errors are properly propagated
        
        // Invalid format error - use space-separated date that bypasses fast-path
        let result = process_single_date_with_error_handling(
            "15 06 2020",
            Some(1),
            Some(1),
            None,
            "invalid_format",
            false,
            false,
        );
        assert!(result.is_err());
        
        // Month out of range error - use space-separated date that bypasses fast-path
        let result = process_single_date_with_error_handling(
            "15 15 2020", // Month 15 is invalid
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        );
        assert!(result.is_err());
        
        // Day out of range error - use space-separated date that bypasses fast-path
        let result = process_single_date_with_error_handling(
            "40 06 2020", // Day 40 is invalid
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        );
        assert!(result.is_err());
    }

    #[test]
    fn test_process_single_date_recoverable_errors() {
        // Test cases where errors should be converted to None instead of propagated
        
        // Empty string should return None, not error
        let result = process_single_date_with_error_handling(
            "",
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, None);
        
        // NA string should return None, not error
        let result = process_single_date_with_error_handling(
            "NA",
            Some(1),
            Some(1),
            None,
            "dmy",
            false,
            false,
        ).unwrap();
        assert_eq!(result, None);
    }

    #[test]
    fn test_validate_year_length() {
        // Test valid 4-digit years
        assert!(validate_year_length("2020").is_ok());
        assert!(validate_year_length("1999").is_ok());
        assert!(validate_year_length("0001").is_ok());
        assert!(validate_year_length("9999").is_ok());
        
        // Test valid shorter years
        assert!(validate_year_length("20").is_ok());
        assert!(validate_year_length("1").is_ok());
        assert!(validate_year_length("").is_ok()); // Empty is technically valid
        
        // Test invalid long years
        assert!(validate_year_length("20201").is_err());
        assert!(validate_year_length("123456").is_err());
        
        // Verify error message
        let result = validate_year_length("20201");
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("unable to tidy"));
    }
}
