#' @title Shiny application standardizing date data in csv of excel files
#' @description A shiny application which allows users to standardize dates
#'   using a graphical user interface (GUI). Most features of \code{datefixR}
#'   are supported including imputing missing date data. Data can be provided as
#'   CSV (comma-separated value) or XLSX (Excel) files. Processed datasets can
#'   be downloaded as CSV files. Please note, the dependencies for this app
#'   (\code{DT}, \code{htmltools}, \code{readxl}, and \code{shiny}) are not
#'   installed alongside \code{datefixR}. This allows \code{datefixR} to be
#'   installed on secure systems where these packages may not be allowed. If one
#'   of these dependencies is not installed on the system when this function is
#'   called, then the user will have the option of installing them.
#' @param theme Color theme for shiny app. Either \code{"datefixR"}
#'   (\code{datefixR} colors) or \code{"none"}(default shiny app styling).
#' @return A shiny app.
#' @seealso The \code{\link[shiny]{shiny}} package.
#' @examples
#' \dontrun{
#' fix_date_app()
#' }
#' @export
fix_date_app <- function(theme = "datefixR") {
  rlang::check_installed(c("DT", "shiny", "readxl", "htmltools"),
    reason = "to use `fix_date_app()`"
  )

  if (!(theme %in% c("datefixR", "none"))) {
    stop("theme should be 'datefixR or 'none' \n")
  }

  ui <- shiny::fluidPage(
    .html_head(theme = theme),
    htmltools::div(
      class = "simpleDiv",
      shiny::titlePanel("datefixR", "datefixR")
    ),
    shiny::fluidRow(
      shiny::column(
        3,
        shiny::wellPanel(
          shiny::fileInput(
            "datafile",
            "File Upload",
            accept = c(".csv", ".xlsx"),
            placeholder = ".xlsx (Excel) or .csv file"
          ),
          shiny::uiOutput("columns"),
          shiny::selectInput("date.input",
            "Day of month to impute",
            choices = c(seq(1, 28), NA)
          ),
          shiny::selectInput("month.input",
            "Month to impute",
            choices = c(seq(1, 12), NA),
            selected = 7
          ),
          shiny::selectInput("format",
            "Assumed format",
            choices = c("dmy", "mdy")
          ),
          shiny::actionButton("do", "Refresh"),
          shiny::downloadButton("downloadData", "Download")
        )
      ),
      shiny::column(
        9,
        shiny::tabsetPanel(
          shiny::tabPanel(
            "Results",
            DT::DTOutput("df")
          ),
          shiny::tabPanel(
            "About this app",
            htmltools::tags$h3("Introduction"),
            htmltools::tags$img(
              src = paste0(
                "https://raw.githubusercontent.com",
                "/nathansam/datefixR/main/man/",
                "figures/logo.png"
              ),
              align = "right",
              width = "150"
            ),
            htmltools::tags$p(
              "Dates can be some of the most infuriating data types to work
              with: especially if the date formats (e.g dd/mm/yyyy or
              yyyy-mm-dd) have not been standardized across observations or
              are missing data such as day of the month. If dates have been
              provided via a free text webfrom, then this is a very likely
              scenario."
            ),
            htmltools::HTML(
              "<p>
                This app uses the
                <a href = 'https://www.constantine-cooke.com/datefixR/'>
                  <code>datefixR</code>
                </a>
                R package to parse dates in many different formats from either
                an xlsx (Excel) or csv file. No knowledge of R is required to
                use this app
              </p>"
            ),
            htmltools::HTML(
              "<p>
                 To use this app, please select <em>Browse</em> in the navbar on
                 the left hand side of the page and select either an  xlsx or
                 CSV file you wish to process. Once the upload is complete,
                 click the <em>Refresh</em> button to show the uploaded data.
                 You can then select the columns you want to fix. Clicking on
                 refresh once more will parse the dates and present the updated
                 dataset. This updated dataset can be downloaded using the
                 download button.
               </p>"
            ),
            htmltools::tags$p(
              "Please note, if you are using this app via an online hosting
              platform, such as on shinyapps.io, then your file will temporarily
              be stored by the hosting platform. However, no data should be
              stored persistently. Nevertheless, user discretion is advised, and
              any sensitive data should be used with a version of this app which
              is running locally."
            ),
            htmltools::h3("License"),
            htmltools::HTML(
              "<p>
                This app, like the rest of <code>datefixR</code>, is licensed
                under
                <a href =
                'https://github.com/nathansam/datefixR/blob/main/LICENSE.md'>
                  GPL-3
                </a>
                .
               </p>"
            ),
            htmltools::h3("Bug Reports"),
            htmltools::HTML("
              <p>
                If you encounter any bugs or have a feature request, please
                create a GitHub Issue
                <a href = 'https://www.github.com/ropensci/datefixR/issues'>
                  here.
                </a>
              </p>"),
            htmltools::tags$hr(),
            "Developed and maintained by",
            htmltools::tags$a(
              href = "https://www.github.com/nathansam",
              "Nathan Constantine-Cooke"
            )
          )
        )
      )
    )
  )
  # Run the application
  return(shiny::shinyApp(ui = ui, server = .server))
}


.html_head <- function(theme) {
  site <- "https://docs.ropensci.org/datefixR/" # replace with ropensci docs

  if (theme == "datefixR") {
    htmltools::tags$head(
      htmltools::tags$style(htmltools::HTML("
        @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300&family=Zen+Tokyo+Zoo&display=swap');

  body {
    font-family: 'Roboto', sans-serif;
    padding: 10px;
  }

  .nav-tabs {
    padding-top: 5px;
  }

   a {
    color: #2a9d8f;
  }

  .tab-content{
    padding-top: 8px;
  }

  .simpleDiv {
    background: #2a9d8f;
    color: #e7c36a;
    display: -webkit-box;
    border: 0px;
    border-radius: 20px;
    font-family: 'Zen Tokyo Zoo', cursive;
    padding: 5px;
    border-bottom-right-radius: 0px;
    border-bottom-left-radius: 0px;
    border-bottom-width: 5px;
    border-bottom-color: #1b333a;
    border-bottom-style: solid;
  }

  hr {
    border-top: 2px solid #1b333a;
  }

  .simpleDiv h2 {
      font-size: 40px !important;
      float: none !important;
      margin: 0 auto !important;
    }

  .shiny-options-group {
    border-radius: 4px;
    padding: 5px;
    padding-left: 10px;
    background-color: #264653 ;
  }


  .well {
    background-color: #2a9d8f !important;
    color: white !important;
    border: 0px;
    height: 90vh;
    border-radius: 0px;
    border-bottom-left-radius: 20px;
    border-right-width: 5px;
    border-right-color: #1b333a;
    border-right-style: solid;
  }

  .col-sm-8 {
    padding-top: 20px !important;
  }

  .container-fluid {
    padding-right: 0px !important;
    padding-left: 0px !important;
  }

  .btn-default {
    background-color: #264653 !important;
    color: white !important;
  }")),
      htmltools::tags$link(
        rel = "icon",
        type = "image/png",
        sizes = "16x16",
        href = paste0(site, "favicon-16x16.png")
      ),
      htmltools::tags$link(
        rel = "icon",
        type = "image/png",
        sizes = "32x32",
        href = paste0(site, "favicon-32x32.png")
      ),
      htmltools::tags$link(
        rel = "apple-touch-icon",
        type = "image/png",
        sizes = "180x180",
        href = paste0(site, "apple-touch-icon.png")
      ),
      htmltools::tags$link(
        rel = "apple-touch-icon",
        type = "image/png",
        sizes = "120x120",
        href = paste0(site, "apple-touch-icon-120x120.png")
      ),
      htmltools::tags$link(
        rel = "apple-touch-icon",
        type = "image/png",
        sizes = "76x76",
        href = paste0(site, "apple-touch-icon-76x76.png")
      ),
      htmltools::tags$link(
        rel = "apple-touch-icon",
        type = "image/png",
        sizes = "60x60",
        href = paste0(site, "apple-touch-icon-60x60.png")
      ),
      htmltools::tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "style.css"
      )
    )
  } else {
    htmltools::tags$head(
      htmltools::tags$link(
        rel = "icon",
        type = "image/png",
        sizes = "16x16",
        href = paste0(site, "favicon-16x16.png")
      ),
      htmltools::tags$link(
        rel = "icon",
        type = "image/png",
        sizes = "32x32",
        href = paste0(site, "favicon-32x32.png")
      ),
      htmltools::tags$link(
        rel = "apple-touch-icon",
        type = "image/png",
        sizes = "180x180",
        href = paste0(site, "apple-touch-icon.png")
      ),
      htmltools::tags$link(
        rel = "apple-touch-icon",
        type = "image/png",
        sizes = "120x120",
        href = paste0(site, "apple-touch-icon-120x120.png")
      ),
      htmltools::tags$link(
        rel = "apple-touch-icon",
        type = "image/png",
        sizes = "76x76",
        href = paste0(site, "apple-touch-icon-76x76.png")
      ),
      htmltools::tags$link(
        rel = "apple-touch-icon",
        type = "image/png",
        sizes = "60x60",
        href = paste0(site, "apple-touch-icon-60x60.png")
      ),
      htmltools::tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "style.css"
      )
    )
  }
}

.server <- function(input, output) {
  output.data <- NULL
  shiny::observeEvent(input$do, {
    input.data <- .read_data(input$datafile)
    if (!any(is.null(input$selected.columns))) {
      output.data <- fix_date_df(input.data,
        col.names = input$selected.columns,
        day.impute = as.numeric(input$date.input),
        month.impute = as.numeric(input$month.input)
      )
    }
    if (is.null(output.data)) {
      output.data <- input.data
    }
    output$df <- DT::renderDT({
      output.data
    })
    output$columns <- shiny::renderUI({
      shiny::checkboxGroupInput(
        "selected.columns",
        "",
        colnames(input.data)
      )
    })
    output$downloadData <- shiny::downloadHandler(
      filename = function() {
        "fixed.csv"
      },
      content = function(file) {
        input.data <- .read_data(input$datafile)
        if (!any(is.null(input$selected.columns))) {
          output.data <- fix_date_df(input.data,
            col.names = input$selected.columns
          )
        }
        utils::write.csv(output.data, file)
      }
    )
  })
}

.read_data <- function(upload) {
  if (!is.null(upload)) {
    ext <- tools::file_ext(upload$datapath)
    if (ext == "csv") {
      return((utils::read.csv(upload$datapath)))
    } else {
      return(as.data.frame(readxl::read_xlsx(upload$datapath)))
    }
  }
}
