utils::globalVariables(c("PredictedY", "Residuals_Student", "theme", "element_text", "margin"))
#' Studentized Residual Plot for Linear Regression Model Output
#'
#' Generates a studentized residual plot to assess the assumptions of a linear model.
#'
#' This function creates a residual plot for a fitted linear model, highlighting studentized residuals.
#' The plot includes reference bands at ±2 and ±3 standard deviations, a smoothed LOESS curve,
#' and predicted vs residual points to help visualize potential issues with linearity or heteroscedasticity.
#'
#' @param mymodel A fitted linear model (`lm` object).
#' @return A `ggplot2` object showing studentized residuals plotted against predicted values.
#' The plot visually indicates whether residuals are randomly scattered (suggesting a good fit)
#' or show systematic patterns (indicating potential issues with model assumptions).
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_smooth labs theme_linedraw geom_rect geom_hline geom_vline coord_cartesian ggplot_build theme element_text margin
#' @importFrom dplyr mutate
#' @importFrom stats predict rstudent na.omit
#' @export
#'
#' @examples
#' # Example 1: Using the built-in mtcars dataset
#' data(mtcars)
#' model_mtcars <- lm(mpg ~ wt, data = mtcars)
#' lmplot_student_fits(model_mtcars)
#'
#' # Example 2: Using the diamonds dataset from the yarrr package (if available)
#' if (requireNamespace("yarrr", quietly = TRUE)) {
#'   data("diamonds", package = "yarrr")
#'   model_diamonds <- lm(value ~ weight, data = diamonds)
#'   lmplot_student_fits(model_diamonds)
#' } else {
#'   message("Install the Yarrr package with install.packages('yarrr').")
#' }
lmplot_student_fits <- function(mymodel) {

   mydata <- data.frame(PredictedY=predict(mymodel),Residuals_Student=rstudent(mymodel))


   # Define axis limits
   ymax <- max(c(ceiling(abs(range(mydata$Residuals_Student, na.rm = TRUE)))), 2.5)
   ylims <- c(-ymax, ymax)
   vlines <- pretty(range(mydata$PredictedY, na.rm = TRUE), n = 4)
   hlines <- c(1, 2, 3, -1, -2, -3)

   # Base plot
   outputplot <- suppressMessages(ggplot(mydata, aes(x = PredictedY, y = Residuals_Student)) +

      # Background shading for reference ranges
      geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -4, ymax = 4),fill = "#ccebc5", linewidth=0) +
      geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -3, ymax = 3), fill = "#e0f3db", alpha = 0.8, linewidth=0) +
      geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -2, ymax = 2),fill = "#f7fcf0", alpha = 0.8, linewidth=0) +

      # Horizontal and vertical reference lines
      geom_hline(yintercept=0,       color="black",   linewidth=0.2) +
      geom_hline(yintercept=hlines,  color="gray80", linewidth=0.2, linetype="dotted") +
      geom_vline(xintercept = vlines,color = "gray80",linewidth = 0.5,linetype="dotted") +

      # Smoothed fit curve
      geom_smooth(method = "loess", col = "gray50", alpha = 0.15, na.rm = TRUE, linewidth = 0,
                  span = 0.9, level = 0.999) +

      # Scatter plot points
      geom_point(colour = "black", alpha = 0.7) +

      # Labels and styling
      labs(
         x = "Predicted response from model",
         y = "Studentized residual",
         subtitle = "Approximately 95% of data-points should fall between -2 and +2"
      ) +
      theme_linedraw() +
      theme(
         plot.subtitle = element_text(size = 9, hjust = 1),  # Right-align and shrink subtitle
         axis.text = element_text(size = 11),  # Increase axis tick label size
         axis.title = element_text(size = 12),  # Slightly larger axis titles
         axis.title.x = element_text(margin = margin(t = 10)),  # Moves x-label downward
         axis.title.y = element_text(margin = margin(r = 10))))

   # Extract smoothing curve data
   smoothed_data <- suppressMessages(na.omit(ggplot_build(outputplot)$data[[7]]))

   # Find min and max x values from the smoothed curve
   smooth_x_range <- range(smoothed_data$x, mydata$PredictedY, na.rm = TRUE)

   # Update coord_cartesian to ensure full range of smoothing curve
   outputplot <- outputplot + coord_cartesian(ylim = ylims, xlim = smooth_x_range)

   return(outputplot)
}
