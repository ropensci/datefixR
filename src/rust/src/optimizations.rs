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
}
