use extendr_api::prelude::*;

/// Private helper function to replace multiple patterns in a string
fn replace_all<'a>(input: &'a str, patterns: &[(&str, &str)]) -> String {
    let mut out = input.to_string();
    for (from, to) in patterns {
        out = out.replace(from, to);
    }
    out
}


/// Process French date strings by removing articles and normalizing ordinals
/// @export
#[extendr]
fn process_french(date: &str) -> String {
    replace_all(
        date,
        &[("le ", " "), ("Le ", " "), ("1er", "01")],
    )
}

/// Process Russian date strings by normalizing months
/// @export
#[extendr]
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
/// @export
#[extendr]
fn imputemonth(month_impute: Option<&str>) -> Result<()> {
    if month_impute.is_none() {
        Err("Missing month with no imputation value given".into())
    } else {
        Ok(())
    }
}

/// Validate day imputation value
/// @export
#[extendr]
fn imputeday(day_impute: Option<&str>) -> Result<()> {
    if day_impute.is_none() {
        Err("Missing day with no imputation value given".into())
    } else {
        Ok(())
    }
}

/// Validate day imputation value range
/// @export
#[extendr]
fn checkday(day_impute: Robj) -> Result<()> {
    if day_impute.is_null() || day_impute.len() == 0 {
        return Ok(());             // nothing to check
    }
    let val: f64 = day_impute
        .as_real()
        .ok_or("day.impute must be numeric")?;
    if val.is_nan() {
        return Ok(());
    }
    if val.fract() != 0.0 {
        return Err("day.impute should be an integer".into());
    }
    if !(1.0..=31.0).contains(&val) {
        return Err("day.impute should be an integer between 1 and 31".into());
    }
    Ok(())
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
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process_french() {
        let result = process_french("Le 1er janvier");
        assert_eq!(result, " 01 janvier");
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
}
