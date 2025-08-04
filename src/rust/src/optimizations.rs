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
pub fn rm_ordinal_suffixes_optimized(date: &str) -> Cow<str> {
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
pub fn convert_text_month_optimized(date: &str) -> Cow<str> {
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
        // Spanish date - use split instead of regex for common cases
        if date.contains(" de ") {
            date.split(" de ").collect()
        } else {
            date.split(" del ").collect()
        }
    } else if date.contains('.') {
        // German date - simplified splitting for common cases
        date.split(&['.', ' '][..]).filter(|s| !s.is_empty()).collect()
    } else if date.contains(' ') {
        date.split(' ').collect()
    } else {
        vec![date]
    }
}

/// Pre-compiled fast path for common date formats
pub fn fast_path_parse(date: &str) -> Option<(u8, u8, u16)> {
    // Handle common formats without regex
    match date.len() {
        10 => {
            // YYYY-MM-DD or DD/MM/YYYY format
            if date.chars().nth(4) == Some('-') && date.chars().nth(7) == Some('-') {
                // ISO format YYYY-MM-DD
                if let (Ok(year), Ok(month), Ok(day)) = (
                    date[0..4].parse::<u16>(),
                    date[5..7].parse::<u8>(),
                    date[8..10].parse::<u8>(),
                ) {
                    if month <= 12 && day <= 31 && year >= 1900 && year <= 2100 {
                        return Some((day, month, year));
                    }
                }
            } else if date.chars().nth(2) == Some('/') && date.chars().nth(5) == Some('/') {
                // DD/MM/YYYY format
                if let (Ok(day), Ok(month), Ok(year)) = (
                    date[0..2].parse::<u8>(),
                    date[3..5].parse::<u8>(),
                    date[6..10].parse::<u16>(),
                ) {
                    if month <= 12 && day <= 31 && year >= 1900 && year <= 2100 {
                        return Some((day, month, year));
                    }
                }
            }
        }
        8 => {
            // DD/MM/YY format
            if date.chars().nth(2) == Some('/') && date.chars().nth(5) == Some('/') {
                if let (Ok(day), Ok(month), Ok(year_short)) = (
                    date[0..2].parse::<u8>(),
                    date[3..5].parse::<u8>(),
                    date[6..8].parse::<u8>(),
                ) {
                    if month <= 12 && day <= 31 {
                        let year = if year_short <= 25 { 2000 + year_short as u16 } else { 1900 + year_short as u16 };
                        return Some((day, month, year));
                    }
                }
            }
        }
        _ => {}
    }
    None
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fast_path_parse() {
        assert_eq!(fast_path_parse("2020-12-25"), Some((25, 12, 2020)));
        assert_eq!(fast_path_parse("25/12/2020"), Some((25, 12, 2020)));
        assert_eq!(fast_path_parse("25/12/99"), Some((25, 12, 1999)));
        assert_eq!(fast_path_parse("25/12/23"), Some((25, 12, 2023)));
        assert_eq!(fast_path_parse("invalid"), None);
    }

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
}
