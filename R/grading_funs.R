#' Extract highest and lowest grades from a data frame
#'
#' @description \code{grading} is just a package that returns grades for exams from highest to  lowest
#' @details \code{grading} requires some exam data
#'
#'
#'
#'
#' @param data is a `data.frame` that you need  graded
#' @param ... pass of starts_with() since that will make your life easiers
#' @return is your graded data
#'
#'
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#'
#' set.seed(123456)
#'     students = 26
#'            student_data = tibble(id = 1:26,
#'            Students = LETTERS,
#'            Exam_1 = rnorm(students, mean = 85, sd = 5),
#'            Exam_2 = rnrom(students, mean = 77, sd = 5),
#'            Exam_3 = rnorm(students, mean = 70, sd = 5))
#'
#'  your_graded_data = grading(starts_with("exam"),dat = your_exam_Data)
#'     }
#'@export



grading = function(...,data = NULL){

  data = data |>
    rowwise() |>
    mutate(high_exam = round(max(c_across(...), na.rm = TRUE)),
           low_exam = round(min(c_across(...),  na.rm = TRUE)))


  data$second_high_exam = data |>
    select(...) %>%
    apply(., 1, function(row){
      round(sort(row, decreasing = TRUE)[2])
    })

  return(data)

}


#'@export

