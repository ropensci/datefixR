use std::borrow::Cow;
use regex::Regex;
use std::collections::HashMap;
use std::sync::OnceLock;

/// Fast lookup table for month names to avoid regex matching
static MONTH_LOOKUP: OnceLock<HashMap<&'static str, u8>> = OnceLock::new();

/// Initialize month lookup table for fast month name detection
fn get_month_lookup() -> &'static HashMap<&'static str, u8> {
    MONTH_LOOKUP.get_or_init(|| {
        let mut lookup = HashMap::new();
        
        // Month 1 - January
        for name in ["january", "janvier", "janeiro", "janv", "januar", "jänner", "jän", "enero", "ener", "ene", "jan", "январь", "января", "янв", "januari"] {
            lookup.insert(name, 1);
        }
        
        // Month 2 - February
        for name in ["february", "février", "fevrier", "fevereiro", "févr", "fevr", "fev", "februar", "febrero", "feb", "февраль", "февраля", "фев", "februari"] {
            lookup.insert(name, 2);
        }
        
        // Month 3 - March
        for name in ["march", "mars", "märz", "marzo", "março", "marco", "marz", "mar", "март", "мар", "maret"] {
            lookup.insert(name, 3);
        }
        
        // Month 4 - April
        for name in ["april", "avril", "abril", "abr", "apr", "апрель", "апреля", "апр"] {
            lookup.insert(name, 4);
        }
        
        // Month 5 - May
        for name in ["mayo", "may", "maio", "mai", "май", "мая", "mei"] {
            lookup.insert(name, 5);
        }
        
        // Month 6 - June
        for name in ["june", "juin", "junio", "junho", "juni", "jun", "июнь", "июня", "июн"] {
            lookup.insert(name, 6);
        }
        
        // Month 7 - July
        for name in ["july", "juillet", "juil", "julio", "julho", "juli", "jul", "июль", "июля", "июл"] {
            lookup.insert(name, 7);
        }
        
        // Month 8 - August
        for name in ["august", "aug", "août", "aout", "agosto", "август", "авг", "agustus"] {
            lookup.insert(name, 8);
        }
        
        // Month 9 - September
        for name in ["september", "septembre", "septiembre", "setembro", "set", "sept", "sep", "сентябрь", "сентября", "сент"] {
            lookup.insert(name, 9);
        }
        
        // Month 10 - October
        for name in ["october", "octobre", "oktober", "okt", "octubre", "outubro", "oct", "out", "октябрь", "октября", "окт"] {
            lookup.insert(name, 10);
        }
        
        // Month 11 - November
        for name in ["november", "novembre", "noviembre", "novembro", "nov", "ноябрь", "ноября", "ноя"] {
            lookup.insert(name, 11);
        }
        
        // Month 12 - December
        for name in ["december", "décembre", "decembre", "déc", "dezember", "dezembro", "dez", "diciembre", "dic", "dec", "декабрь", "декабря", "дек", "desember"] {
            lookup.insert(name, 12);
        }
        
        lookup
    })
}

/// Optimized replace_all function using Cow to avoid unnecessary allocations
pub fn replace_all_optimized<'a>(input: &'a str, patterns: &[(&str, &str)]) -> Cow<'a, str> {
    let mut result = Cow::Borrowed(input);
    for (from, to) in patterns {
        if result.contains(from) {
            result = Cow::Owned(result.replace(from, to));
        }
    }
    result
}

/// Optimized ordinal suffix removal using a single regex and pre-allocated capacity
pub fn rm_ordinal_suffixes_optimized(date: &str) -> Cow<'_, str> {
    // Single compiled regex for all ordinal patterns
    static ORDINAL_REGEX: std::sync::OnceLock<Regex> = std::sync::OnceLock::new();
    let regex = ORDINAL_REGEX.get_or_init(|| {
        Regex::new(r"(\d)(?:st|nd|rd|th)(,?)").unwrap()
    });
    
    if regex.is_match(date) {
        Cow::Owned(regex.replace_all(date, "$1$2").to_string())
    } else {
        Cow::Borrowed(date)
    }
}

/// Fast month name detection using hash table lookup
pub fn fast_month_lookup(text: &str) -> Option<u8> {
    let lookup = get_month_lookup();
    lookup.get(text.to_lowercase().as_str()).copied()
}

/// Optimized month conversion using fast lookup table instead of regex
pub fn convert_text_month_optimized(date: &str) -> Cow<'_, str> {
    let mut result = Cow::Borrowed(date);
    let mut needs_lowercase = false;
    
    // Check each word in the date string for month names
    let words: Vec<&str> = date.split_whitespace().collect();
    for word in &words {
        let clean_word = word.trim_matches(|c: char| !c.is_alphabetic());
        if let Some(month_num) = fast_month_lookup(clean_word) {
            let month_str = if month_num < 10 {
                format!("0{}", month_num)
            } else {
                month_num.to_string()
            };
            
            // Only create new string if we need to replace
            if result.as_ref() != date.replace(word, &month_str) {
                result = Cow::Owned(result.replace(word, &month_str));
            }
        } else if clean_word != clean_word.to_lowercase() {
            needs_lowercase = true;
        }
    }
    
    // Apply lowercase if needed and no month replacement occurred
    if needs_lowercase && matches!(result, Cow::Borrowed(_)) {
        result = Cow::Owned(date.to_lowercase());
    }
    
    result
}

/// Optimized date separation avoiding multiple allocations
pub fn separate_date_optimized(date: &str) -> Vec<&str> {
    if date.contains('/') {
        date.split('/').collect()
    } else if date.contains('-') {
        date.split('-').collect()
    } else if date.contains(" de ") || date.contains(" del ") {
        // Spanish date - handle both "de" and "del" patterns
        // Compile regex lazily for performance but only when needed
        static SPANISH_REGEX: std::sync::OnceLock<Regex> = std::sync::OnceLock::new();
        let regex = SPANISH_REGEX.get_or_init(|| {
            Regex::new(r" de | del ").unwrap()
        });
        regex.split(date).filter(|s| !s.is_empty()).collect()
    } else if date.contains('.') {
        // German date - simplified splitting for common cases
        date.split(&['.', ' '][..]).filter(|s| !s.is_empty()).collect()
    } else if date.contains(' ') {
        date.split(' ').collect()
    } else {
        vec![date]
    }
}

/// Fast-path parser for common date formats to bypass complex processing
pub fn fast_path_parse_date(date: &str, format: &str) -> Option<(u8, u8, u16)> {
    match date.len() {
        10 => {
            // YYYY-MM-DD format (ISO) - always unambiguous
            if date.chars().nth(4) == Some('-') && date.chars().nth(7) == Some('-') {
                if let (Ok(year), Ok(month), Ok(day)) = (
                    date[0..4].parse::<u16>(),
                    date[5..7].parse::<u8>(),
                    date[8..10].parse::<u8>(),
                ) {
                    if month >= 1 && month <= 12 && day >= 1 && day <= 31 {
                        // Return even if day might be invalid for this month (e.g., Feb 30)
                        // The main validation logic will handle month-specific day limits
                        return Some((day, month, year));
                    }
                }
            }
            // MM/DD/YYYY or DD/MM/YYYY format - depends on format parameter
            else if date.chars().nth(2) == Some('/') && date.chars().nth(5) == Some('/') {
                if let (Ok(first), Ok(second), Ok(year)) = (
                    date[0..2].parse::<u8>(),
                    date[3..5].parse::<u8>(),
                    date[6..10].parse::<u16>(),
                ) {
                    // Only use fast path for unambiguous cases or explicit format
                    match format {
                        "mdy" => {
                            // MM/DD/YYYY format
                            if first >= 1 && first <= 12 && second >= 1 && second <= 31 {
                                return Some((second, first, year));
                            }
                        }
                        "dmy" => {
                            // DD/MM/YYYY format  
                            if second >= 1 && second <= 12 && first >= 1 && first <= 31 {
                                return Some((first, second, year));
                            }
                        }
                        _ => {
                            // For unspecified format, only handle unambiguous cases
                            // If first > 12, must be DD/MM/YYYY
                            if first > 12 && second >= 1 && second <= 12 {
                                return Some((first, second, year));
                            }
                            // If second > 12, must be MM/DD/YYYY
                            else if second > 12 && first >= 1 && first <= 12 {
                                return Some((second, first, year));
                            }
                            // Otherwise ambiguous - let main logic handle it
                        }
                    }
                }
            }
        }
        8 => {
            // MM/DD/YY or DD/MM/YY format - only handle if format is specified
            if date.chars().nth(2) == Some('/') && date.chars().nth(5) == Some('/') {
                if let (Ok(first), Ok(second), Ok(year_short)) = (
                    date[0..2].parse::<u8>(),
                    date[3..5].parse::<u8>(),
                    date[6..8].parse::<u8>(),
                ) {
                    let year = if year_short <= 30 { 2000 + year_short as u16 } else { 1900 + year_short as u16 };
                    
                    match format {
                        "mdy" => {
                            // MM/DD/YY format
                            if first >= 1 && first <= 12 && second >= 1 && second <= 31 {
                                return Some((second, first, year));
                            }
                        }
                        "dmy" => {
                            // DD/MM/YY format
                            if second >= 1 && second <= 12 && first >= 1 && first <= 31 {
                                return Some((first, second, year));
                            }
                        }
                        _ => {
                            // For unspecified format, only handle unambiguous cases
                            if first > 12 && second >= 1 && second <= 12 {
                                return Some((first, second, year));
                            }
                            else if second > 12 && first >= 1 && first <= 12 {
                                return Some((second, first, year));
                            }
                        }
                    }
                }
            }
        }
        _ => {}
    }
    None
}

/// Combined string cleaning function to reduce multiple passes
pub fn clean_date_string_combined(date: &str) -> Cow<'_, str> {
    // Check if any cleaning is needed first
    let needs_ordinal = date.contains("st") || date.contains("nd") || date.contains("rd") || date.contains("th");
    let needs_french = date.contains("le ") || date.contains("Le ") || date.contains("1er");
    let needs_russian = date.contains("марта") || date.contains("Марта") || date.contains("августа") || date.contains("Августа");
    
    if !needs_ordinal && !needs_french && !needs_russian {
        let trimmed = date.trim();
        return if trimmed.len() == date.len() {
            Cow::Borrowed(date)
        } else {
            Cow::Owned(trimmed.to_string())
        };
    }
    
    // Apply ordinal suffix removal first
    let mut result = if needs_ordinal {
        rm_ordinal_suffixes_optimized(date).into_owned()
    } else {
        date.to_string()
    };
    
    // Apply French replacements
    if needs_french {
        result = replace_all_optimized(&result, &[("le ", " "), ("Le ", " "), ("1er", "01")]).into_owned();
    }
    
    // Apply Russian replacements
    if needs_russian {
        result = replace_all_optimized(&result, &[
            ("марта", "март"),
            ("Марта", "Март"),
            ("августа", "август"),
            ("Августа", "Август"),
        ]).into_owned();
    }
    
    // Trim and return
    result = result.trim().to_string();
    Cow::Owned(result)
}


#[cfg(test)]
mod tests {
    use super::*;


    #[test]
    fn test_replace_all_optimized() {
        let result = replace_all_optimized("hello world", &[("world", "rust")]);
        assert_eq!(result, "hello rust");
        
        // Test no allocation when no replacement needed
        let result = replace_all_optimized("hello world", &[("foo", "bar")]);
        assert_eq!(result, "hello world");
        if let Cow::Borrowed(_) = result {
            // Good, no allocation
        } else {
            panic!("Should not allocate when no replacement needed");
        }
    }
    
    #[test]
    fn test_convert_text_month_optimized() {
        assert_eq!(convert_text_month_optimized("July 4th, 1776"), "07 4th, 1776");
        assert_eq!(convert_text_month_optimized("january 2020"), "01 2020");
        assert_eq!(convert_text_month_optimized("06 de enero del 2008"), "06 de 01 del 2008");
    }
    
    #[test]
    fn test_separate_date_optimized() {
        assert_eq!(separate_date_optimized("06 de enero del 2008"), vec!["06", "enero", "2008"]);
        assert_eq!(separate_date_optimized("July 4th, 1776"), vec!["July", "4th,", "1776"]);
    }
    
    #[test]
    fn test_rm_ordinal_suffixes_optimized() {
        assert_eq!(rm_ordinal_suffixes_optimized("1st January"), "1 January");
        assert_eq!(rm_ordinal_suffixes_optimized("July 4th, 1776"), "July 4, 1776");
        assert_eq!(rm_ordinal_suffixes_optimized("4th,"), "4,");
    }
    
    #[test]
    fn test_fast_path_parse_date() {
        // Test ISO format (always unambiguous)
        assert_eq!(fast_path_parse_date("2020-12-25", "dmy"), Some((25, 12, 2020)));
        assert_eq!(fast_path_parse_date("2020-01-01", "mdy"), Some((1, 1, 2020)));
        
        // Test DD/MM/YYYY format with dmy
        assert_eq!(fast_path_parse_date("25/12/2020", "dmy"), Some((25, 12, 2020)));
        
        // Test MM/DD/YYYY format with mdy
        assert_eq!(fast_path_parse_date("12/25/2020", "mdy"), Some((25, 12, 2020)));
        
        // Test unambiguous cases (format doesn't matter)
        assert_eq!(fast_path_parse_date("25/01/2020", ""), Some((25, 1, 2020))); // 25 > 12, must be DD/MM
        assert_eq!(fast_path_parse_date("01/25/2020", ""), Some((25, 1, 2020))); // 25 > 12, must be MM/DD
        
        // Test short year formats
        assert_eq!(fast_path_parse_date("25/12/99", "dmy"), Some((25, 12, 1999)));
        assert_eq!(fast_path_parse_date("12/25/23", "mdy"), Some((25, 12, 2023)));
        
        // Test invalid formats
        assert_eq!(fast_path_parse_date("invalid", "dmy"), None);
        
        // Test ambiguous cases without format (should pass through)
        assert_eq!(fast_path_parse_date("01/02/2020", ""), None); // Ambiguous, let main logic handle
    }
    
    #[test]
    fn test_clean_date_string_combined() {
        // Test no cleaning needed
        assert_eq!(clean_date_string_combined("25/12/2020"), "25/12/2020");
        
        // Test ordinal suffix removal
        assert_eq!(clean_date_string_combined("July 4th, 1776"), "July 4, 1776");
        
        // Test French cleaning
        assert_eq!(clean_date_string_combined("le 1er janvier"), "01 janvier");
        
        // Test Russian cleaning
        assert_eq!(clean_date_string_combined("15 марта 2020"), "15 март 2020");
        
        // Test combined cleaning
        assert_eq!(clean_date_string_combined("le 4th марта"), "4 март");
    }
}
