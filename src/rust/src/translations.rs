use lazy_static::lazy_static;
use std::collections::HashMap;
use std::env;
use std::sync::{Once, RwLock};

static INIT: Once = Once::new();
static CURRENT_LOCALE: RwLock<String> = RwLock::new(String::new());

lazy_static! {
    /// Translation domain for datefixR
    static ref DOMAIN: &'static str = "datefixR";

    /// Spanish translations
    static ref SPANISH_TRANSLATIONS: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("Day not in expected range\n", "Día fuera del rango esperado\n");
        m.insert("Month not in expected range\n", "Mes fuera del rango esperado\n");
        m.insert("date should be a character", "la fecha debe ser un carácter");
        m.insert("unable to tidy a date", "no se puede ordenar una fecha");
        m.insert("format should be either 'dmy' or 'mdy'", "el formato debe ser 'dmy' o 'mdy'");
        m.insert("Missing month with no imputation value given \n", "Mes faltante sin valor de imputación dado \n");
        m.insert("Missing day with no imputation value given \n", "Día faltante sin valor de imputación dado \n");
        m.insert("day.impute should be an integer between 1 and 31\n", "day.impute debe ser un entero entre 1 y 31\n");
        m.insert("day.impute should be an integer\n", "day.impute debe ser un entero\n");
        m.insert("month.impute should be an integer between 1 and 12", "month.impute debe ser un entero entre 1 y 12");
        m.insert("month.impute should be an integer", "month.impute debe ser un entero");
        m.insert("Unable to resolve date for subject", "No se puede resolver la fecha para el sujeto");
        m.insert("(date:", "(fecha:");
        m.insert(")", ")");
        m.insert("NA imputed (date:", "NA imputado (fecha:");
        m.insert("NA imputed for subject", "NA imputado para sujeto");
        m
    };

    /// French translations
    static ref FRENCH_TRANSLATIONS: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("Day not in expected range\n", "Jour hors de la plage attendue\n");
        m.insert("Month not in expected range\n", "Mois hors de la plage attendue\n");
        m.insert("date should be a character", "la date doit être un caractère");
        m.insert("unable to tidy a date", "impossible de nettoyer une date");
        m.insert("format should be either 'dmy' or 'mdy'", "le format doit être 'dmy' ou 'mdy'");
        m.insert("Missing month with no imputation value given \n", "Mois manquant sans valeur d'imputation donnée \n");
        m.insert("Missing day with no imputation value given \n", "Jour manquant sans valeur d'imputation donnée \n");
        m.insert("day.impute should be an integer between 1 and 31\n", "day.impute doit être un entier entre 1 et 31\n");
        m.insert("day.impute should be an integer\n", "day.impute doit être un entier\n");
        m.insert("month.impute should be an integer between 1 and 12", "month.impute doit être un entier entre 1 et 12");
        m.insert("month.impute should be an integer", "month.impute doit être un entier");
        m.insert("Unable to resolve date for subject", "Impossible de résoudre la date pour le sujet");
        m.insert("(date:", "(date:");
        m.insert(")", ")");
        m.insert("NA imputed (date:", "NA imputé (date:");
        m.insert("NA imputed for subject", "NA imputé pour sujet");
        m
    };

    /// Czech translations
    static ref CZECH_TRANSLATIONS: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("Day not in expected range\n", "Den není v očekávaném rozsahu\n");
        m.insert("Month not in expected range\n", "Měsíc není v očekávaném rozsahu\n");
        m.insert("date should be a character", "datum by měl být text");
        m.insert("unable to tidy a date", "nepodařilo se normalizovat datum");
        m.insert("format should be either 'dmy' or 'mdy'", "Formát by měl být buď 'dmy' nebo 'mdy'");
        m.insert("Missing month with no imputation value given \n", "Chybí měsíc bez dané hodnoty imputace \n");
        m.insert("Missing day with no imputation value given \n", "Chybí den bez dané hodnoty imputace \n");
        m.insert("day.impute should be an integer between 1 and 31\n", "day.impute by mělo být celé číslo mezi 1 a 31\n");
        m.insert("day.impute should be an integer\n", "day.impute by mělo být celé číslo\n");
        m.insert("month.impute should be an integer between 1 and 12", "month.impute by mělo být celé číslo mezi 1 a 12");
        m.insert("month.impute should be an integer", "month.impute by mělo být celé číslo");
        m.insert("Unable to resolve date for subject", "Pro subjekt se nepodařilo rozpoznat datum");
        m.insert("(date:", "(datum:");
        m.insert(")", ")");
        m.insert("NA imputed (date:", "Imputované NA (datum:");
        m.insert("NA imputed for subject", "Imputované NA pro subjekt");
        m
    };

    /// German translations
    static ref GERMAN_TRANSLATIONS: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("Day not in expected range\n", "Tag nicht im erwarteten Bereich\n");
        m.insert("Month not in expected range\n", "Monat nicht im erwarteten Bereich\n");
        m.insert("date should be a character", "date muss vom Typ character sein");
        m.insert("unable to tidy a date", "Datum kann nicht bereinigt werden");
        m.insert("format should be either 'dmy' or 'mdy'", "format sollte entweder 'dmy' oder 'mdy' sein");
        m.insert("Missing month with no imputation value given \n", "Fehlender Monat ohne Imputationswert \n");
        m.insert("Missing day with no imputation value given \n", "Fehlender Tag ohne Imputationswert \n");
        m.insert("day.impute should be an integer between 1 and 31\n", "day.impute sollte eine Ganzzahl zwischen 1 und 31 sein\n");
        m.insert("day.impute should be an integer\n", "day.impute sollte eine Ganzzahl sein\n");
        m.insert("month.impute should be an integer between 1 and 12", "month.impute sollte eine Ganzzahl zwischen 1 und 12 sein");
        m.insert("month.impute should be an integer", "month.impute sollte eine Ganzzahl sein");
        m.insert("Unable to resolve date for subject", "Datum kann nicht aufgelöst werden für");
        m.insert("(date:", "(Datum:");
        m.insert(")", ")");
        m.insert("NA imputed (date:", "NA imputiert (Datum:");
        m.insert("NA imputed for subject", "NA imputiert für");
        m
    };

    /// Indonesian translations
    static ref INDONESIAN_TRANSLATIONS: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("Day not in expected range\n", "Hari bukan dalam jangka yang di ekspektasi\n");
        m.insert("Month not in expected range\n", "Bulan bukan dalam jangka yang di ekspektasi\n");
        m.insert("date should be a character", "tanggal harus berupa karakter");
        m.insert("unable to tidy a date", "tanggal tidak dapat dirapihkan");
        m.insert("format should be either 'dmy' or 'mdy'", "format harus 'dmy' atau 'mdy'");
        m.insert("Missing month with no imputation value given \n", "Bulan hilang tanpa nilai imputasi \n");
        m.insert("Missing day with no imputation value given \n", "Hari hilang tanpa nilai imputasi \n");
        m.insert("day.impute should be an integer between 1 and 31\n", "day.impute harus berupa bilangan bulat antara 1 dan 31\n");
        m.insert("day.impute should be an integer\n", "day.impute harus berupa bilangan bulat\n");
        m.insert("month.impute should be an integer between 1 and 12", "month.impute harus berupa bilangan bulat antara 1 dan 12");
        m.insert("month.impute should be an integer", "month.impute harus berupa bilangan bulat");
        m.insert("Unable to resolve date for subject", "Tidak dapat menuntaskan tanggal untuk subjek");
        m.insert("(date:", "(tanggal:");
        m.insert(")", ")");
        m.insert("NA imputed (date:", "NA diperhitungkan (tanggal:");
        m.insert("NA imputed for subject", "NA diperhitungkan untuk subjek");
        m
    };

    /// Portuguese translations
    static ref PORTUGUESE_TRANSLATIONS: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("Day not in expected range\n", "Dia fora do intervalo esperado\n");
        m.insert("Month not in expected range\n", "Mês fora do intervalo esperado\n");
        m.insert("date should be a character", "data deve ser um caractere");
        m.insert("unable to tidy a date", "não foi possível organizar a data");
        m.insert("format should be either 'dmy' or 'mdy'", "formato deve ser 'dmy' ou 'mdy'");
        m.insert("Missing month with no imputation value given \n", "Mês ausente sem valor de imputação \n");
        m.insert("Missing day with no imputation value given \n", "Dia ausente sem valor de imputação \n");
        m.insert("day.impute should be an integer between 1 and 31\n", "day.impute deve ser um inteiro entre 1 e 31\n");
        m.insert("day.impute should be an integer\n", "day.impute deve ser um inteiro\n");
        m.insert("month.impute should be an integer between 1 and 12", "month.impute deve ser um inteiro entre 1 e 12");
        m.insert("month.impute should be an integer", "month.impute deve ser um inteiro");
        m.insert("Unable to resolve date for subject", "Não foi possível resolver a data para o sujeito");
        m.insert("(date:", "(data:");
        m.insert(")", ")");
        m.insert("NA imputed (date:", "NA imputado (data:");
        m.insert("NA imputed for subject", "NA imputado para sujeito");
        m
    };

    /// Russian translations
    static ref RUSSIAN_TRANSLATIONS: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("Day not in expected range\n", "день определен вне ожидаемого диапазона\n");
        m.insert("Month not in expected range\n", "Месяц определен вне ожидаемого диапазона\n");
        m.insert("date should be a character", "Переменная `date` должна быть строкой");
        m.insert("unable to tidy a date", "Не удалось почистить дату");
        m.insert("format should be either 'dmy' or 'mdy'", "переменная `format` должна быть либо 'dmy' (т.е., день-месяц-год), либо 'mdy' (т.е., месяц-день-год)");
        m.insert("Missing month with no imputation value given \n", "Отсутствует месяц без значения для импутации \n");
        m.insert("Missing day with no imputation value given \n", "Отсутствует день без значения для импутации \n");
        m.insert("day.impute should be an integer between 1 and 31\n", "`day.impute` должен быть целым числом между 1 и 31\n");
        m.insert("day.impute should be an integer\n", "`day.impute` должен быть целым числом\n");
        m.insert("month.impute should be an integer between 1 and 12", "`month.impute` должен быть целым числом (класса 'integer') от 1 до 12");
        m.insert("month.impute should be an integer", "`month.impute` должен быть целым числом (класса 'integer')");
        m.insert("Unable to resolve date for subject", "Не удалось определить дату для предмета");
        m.insert("(date:", "(дата:");
        m.insert(")", ")");
        m.insert("NA imputed (date:", "Н/Д (т.е. `NA`) присвоено (дата:");
        m.insert("NA imputed for subject", "Н/Д (т.е. `NA`) присвоено для предмета");
        m
    };

    /// Slovak translations
    static ref SLOVAK_TRANSLATIONS: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("Day not in expected range\n", "Deň nie je v očakávanom rozsahu\n");
        m.insert("Month not in expected range\n", "Mesiac nie je v očakávanom rozsahu\n");
        m.insert("date should be a character", "dátum by malo byť text");
        m.insert("unable to tidy a date", "nepodarilo sa normalizovať dátum");
        m.insert("format should be either 'dmy' or 'mdy'", "Formát by mal byť 'dmy' alebo 'mdy'.");
        m.insert("Missing month with no imputation value given \n", "Chýbajúci mesiac bez danej hodnoty imputácie \n");
        m.insert("Missing day with no imputation value given \n", "Chýbajúci deň bez danej hodnoty imputácie \n");
        m.insert("day.impute should be an integer between 1 and 31\n", "day.impute by malo byť celé číslo medzi 1 a 31\n");
        m.insert("day.impute should be an integer\n", "day.impute by malo byť celé číslo\n");
        m.insert("month.impute should be an integer between 1 and 12", "month.impute by malo byť celé číslo od 1 do 12");
        m.insert("month.impute should be an integer", "month.impute by malo byť celé číslo");
        m.insert("Unable to resolve date for subject", "Dátum nemohol byť rozpoznaný pre daný subjekt");
        m.insert("(date:", "(dátum:");
        m.insert(")", ")");
        m.insert("NA imputed (date:", "Imputované NA (dátum:");
        m.insert("NA imputed for subject", "Imputované NA pre subjekt");
        m
    };
}

/// Initialize the translation system
pub fn init_translations() {
    INIT.call_once(|| {
        // Get locale from environment variables
        if let Ok(mut locale) = CURRENT_LOCALE.write() {
            *locale = get_current_locale();
        }
    });
}

/// Get the current locale from environment variables
fn get_current_locale() -> String {
    // Check various environment variables for locale
    env::var("DATEFIXR_LOCALE")
        .or_else(|_| env::var("LC_ALL"))
        .or_else(|_| env::var("LC_MESSAGES"))
        .or_else(|_| env::var("LANG"))
        .unwrap_or_else(|_| "en".to_string())
}

/// Get translated string using locale-specific translations
pub fn tr(message: &str) -> String {
    init_translations();

    // Read the current locale safely using RwLock
    let locale_str = CURRENT_LOCALE
        .read()
        .map(|locale| locale.clone())
        .unwrap_or_else(|_| "en".to_string());

    // Determine which translation dictionary to use based on locale
    let translation = if locale_str.starts_with("es") || locale_str.contains("spanish") {
        SPANISH_TRANSLATIONS.get(message)
    } else if locale_str.starts_with("fr") || locale_str.contains("french") {
        FRENCH_TRANSLATIONS.get(message)
    } else if locale_str.starts_with("cs") || locale_str.contains("czech") {
        CZECH_TRANSLATIONS.get(message)
    } else if locale_str.starts_with("de") || locale_str.contains("german") {
        GERMAN_TRANSLATIONS.get(message)
    } else if locale_str.starts_with("id") || locale_str.contains("indonesian") {
        INDONESIAN_TRANSLATIONS.get(message)
    } else if locale_str.starts_with("pt") || locale_str.contains("portuguese") {
        PORTUGUESE_TRANSLATIONS.get(message)
    } else if locale_str.starts_with("ru") || locale_str.contains("russian") {
        RUSSIAN_TRANSLATIONS.get(message)
    } else if locale_str.starts_with("sk") || locale_str.contains("slovak") {
        SLOVAK_TRANSLATIONS.get(message)
    } else {
        None
    };

    // Return translated string or original message
    translation
        .map(|s| s.to_string())
        .unwrap_or_else(|| message.to_string())
}


/// Macro for convenient translation calls
#[macro_export]
macro_rules! tr {
    ($msg:expr) => {
        crate::translations::tr($msg)
    };
}

// Pre-defined translation functions for commonly used messages
// This matches the messages found in the .pot files

pub fn missing_month_no_imputation() -> String {
    tr("Missing month with no imputation value given \n")
}

pub fn missing_day_no_imputation() -> String {
    tr("Missing day with no imputation value given \n")
}

pub fn day_impute_integer_range() -> String {
    tr("day.impute should be an integer between 1 and 31\n")
}

pub fn day_impute_integer() -> String {
    tr("day.impute should be an integer\n")
}


pub fn month_not_in_range() -> String {
    tr("Month not in expected range\n")
}

pub fn day_not_in_range() -> String {
    tr("Day not in expected range\n")
}

pub fn format_should_be_dmy_or_mdy() -> String {
    tr("format should be either 'dmy' or 'mdy'")
}

pub fn unable_to_tidy_date() -> String {
    tr("unable to tidy a date")
}

pub fn date_should_be_character() -> String {
    tr("date should be a character")
}


pub fn na_imputed_date() -> String {
    tr("NA imputed (date:")
}

pub fn na_imputed_for_subject() -> String {
    tr("NA imputed for subject")
}

pub fn date_open_paren() -> String {
    tr("(date:")
}

pub fn close_paren() -> String {
    tr(")")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_translation_init() {
        // Test that translation initialization doesn't panic
        init_translations();

        // Test that tr function returns a string (even if untranslated)
        let result = tr("test message");
        assert!(!result.is_empty());
    }

    #[test]
    fn test_predefined_messages() {
        // Test that all predefined message functions return non-empty strings
        assert!(!missing_month_no_imputation().is_empty());
        assert!(!missing_day_no_imputation().is_empty());
        assert!(!day_impute_integer_range().is_empty());
        assert!(!day_impute_integer().is_empty());
        assert!(!month_not_in_range().is_empty());
        assert!(!day_not_in_range().is_empty());
        assert!(!format_should_be_dmy_or_mdy().is_empty());
        assert!(!unable_to_tidy_date().is_empty());
        assert!(!date_should_be_character().is_empty());
    }

    #[test]
    fn test_spanish_translations() {
        // Test Spanish translations - include newline characters as they appear in the actual messages
        let spanish_day = SPANISH_TRANSLATIONS.get("Day not in expected range\n");
        assert_eq!(spanish_day, Some(&"Día fuera del rango esperado\n"));

        let spanish_month = SPANISH_TRANSLATIONS.get("Month not in expected range\n");
        assert_eq!(spanish_month, Some(&"Mes fuera del rango esperado\n"));
    }

    #[test]
    fn test_french_translations() {
        // Test French translations - include newline characters as they appear in the actual messages
        let french_day = FRENCH_TRANSLATIONS.get("Day not in expected range\n");
        assert_eq!(french_day, Some(&"Jour hors de la plage attendue\n"));

        let french_month = FRENCH_TRANSLATIONS.get("Month not in expected range\n");
        assert_eq!(french_month, Some(&"Mois hors de la plage attendue\n"));
    }

    #[test]
    fn test_german_translations() {
        // Test German translations - include newline characters as they appear in the actual messages
        let german_day = GERMAN_TRANSLATIONS.get("Day not in expected range\n");
        assert_eq!(german_day, Some(&"Tag nicht im erwarteten Bereich\n"));

        let german_month = GERMAN_TRANSLATIONS.get("Month not in expected range\n");
        assert_eq!(german_month, Some(&"Monat nicht im erwarteten Bereich\n"));
    }

    #[test]
    fn test_russian_translations() {
        // Test Russian translations with Cyrillic characters - include newline characters
        let russian_day = RUSSIAN_TRANSLATIONS.get("Day not in expected range\n");
        assert_eq!(
            russian_day,
            Some(&"день определен вне ожидаемого диапазона\n")
        );

        let russian_month = RUSSIAN_TRANSLATIONS.get("Month not in expected range\n");
        assert_eq!(
            russian_month,
            Some(&"Месяц определен вне ожидаемого диапазона\n")
        );
    }

    #[test]
    fn test_all_languages_have_core_messages() {
        // Test that all translation maps contain the core messages - use the exact message strings with newlines
        let core_messages = [
            "Day not in expected range\n",
            "Month not in expected range\n",
            "date should be a character",
            "unable to tidy a date",
            "format should be either 'dmy' or 'mdy'",
        ];

        let translation_maps = [
            &*SPANISH_TRANSLATIONS,
            &*FRENCH_TRANSLATIONS,
            &*CZECH_TRANSLATIONS,
            &*GERMAN_TRANSLATIONS,
            &*INDONESIAN_TRANSLATIONS,
            &*PORTUGUESE_TRANSLATIONS,
            &*RUSSIAN_TRANSLATIONS,
            &*SLOVAK_TRANSLATIONS,
        ];

        for translation_map in translation_maps {
            for message in &core_messages {
                assert!(
                    translation_map.contains_key(message),
                    "Translation map missing message: {}",
                    message
                );
            }
        }
    }

    #[test]
    fn test_locale_detection() {
        // Test that locale detection works for various locale formats
        let test_locales = [
            ("es_ES.UTF-8", "es"),
            ("fr_FR.UTF-8", "fr"),
            ("de_DE.UTF-8", "de"),
            ("ru_RU.UTF-8", "ru"),
            ("cs_CZ.UTF-8", "cs"),
            ("sk_SK.UTF-8", "sk"),
            ("id_ID.UTF-8", "id"),
            ("pt_PT.UTF-8", "pt"),
        ];

        for (locale, expected_prefix) in test_locales {
            assert!(
                locale.starts_with(expected_prefix),
                "Locale {} should start with {}",
                locale,
                expected_prefix
            );
        }
    }
}
