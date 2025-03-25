test_that("lmplot_student_fits runs without error", {
   data(mtcars)
   model_mtcars <- lm(mpg ~ wt, data = mtcars)
   expect_s3_class(lmplot_student_fits(model_mtcars), "ggplot")
})
