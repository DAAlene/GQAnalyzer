#' @section Modified Piper Diagram:
#'
#' The functions defined to create a Modified Piper diagram are:
#' transform_modified_piper_data, ggplot_modified_piper
#'
#' @docType package
#' @name GQAnalyzer
NULL
#' @title
#' modified_piper_transform
#' @description
#' Function to calculate the coordinates of set of samples in a piper diagram.
#' @param gdata A geochemical_dataset
#' @return
#' This function returns a data.frame with the following variables:
#' \itemize{
#' \item cat_x,cat_y: coordinates of the cations in the ternary diagram (scaled between 0 and 1).
#' \item an_x,an_y: coordiantes of the anions in the ternary diagram (scaled between 0 and 1).
#' \item d_x,d_y: coordinates of the samples in the central diamond (scaled between 0 and 1).
#' \item k: Matrix with the increments in the coordinates of the sample tail in the central diamond.
#' }
#' @author
#' Oscar Garcia-Cabrejo \email{khaors@gmail.com}
#' @family modified_piper functions
#' @export
modified_piper_transform <- function(gdata){
  if(class(gdata) != "geochemical_dataset"){
    stop('ERROR: A geochemical_dataset object is required as input')
  }
  h <- 0.5*tan(pi/3)
  offset <- 0.1
  # Coordinates of cations
  cat_x <- 0.5*( 2*gdata$cations[,3] + gdata$cations[,2] )
  cat_y <- h*gdata$cations[,2]
  # Coordinates of anions
  an_x <- 1 + 2*offset + 0.5*( 2*gdata$anions[,3] + gdata$anions[,2] )
  an_y  <- h*gdata$anions[,2]
  # Coordinates inside diamonds
  d_x <- an_y/(4*h) + 0.5*an_x - cat_y/(4*h) + 0.5*cat_x
  d_y <- 0.5*an_y + h*an_x + 0.5*cat_y - h*cat_x
  # Coordinates of mixing concentrations
  mixing_meql <- convert_meql(gdata$mix)
  cat_x_mixing <- 0.5*(2*mixing_meql$cations[,3] + mixing_meql$cations[,2])
  cat_y_mixing <- h*mixing_meql$cations[,2]
  #
  an_x_mixing <- 1 + 2*offset + 0.5*(2*mixing_meql$anions[,3] + mixing_meql$anions[,2])
  an_y_mixing <- h*mixing_meql$anions[,2]
  #
  d_x_mixing <- an_y_mixing/(4*h) + 0.5*an_x_mixing - cat_y_mixing/(4*h) + 0.5*cat_x_mixing
  d_y_mixing <- 0.5*an_y_mixing + h*an_x_mixing + 0.5*cat_y_mixing - h*cat_x_mixing
  # Calculate slopes: joining measured concentrations and expected mixing concentrations
  delta_x <- d_x_mixing - d_x
  delta_y <- d_y_mixing - d_y
  m <- delta_y / delta_x # m is measured from the mixing line
  # Initial coordinates are defined by the measured concentrations.
  # Calculate final coordinates
  d <- 0.035
  k1 <- d/sqrt(1+m^2)
  k2 <- -d/sqrt(1+m^2)
  kk <- cbind(k1, k2)
  # New coordinates
  fx <- d_x + k2
  fy <- d_y + k2*m
  # Final results
  results <- list(cat_x = cat_x, cat_y = cat_y, an_x = an_x, an_y = an_y,
                  d_x = d_x, d_y = d_y, cat_x_mixing = cat_x_mixing,
                  cat_y_mixing = cat_y_mixing, d_x_mixing = d_x_mixing,
                  d_y_mixing = d_y_mixing, m = m, k = kk, fx = fx, fy = fy)
  #
  return(as.data.frame(results))
}
#' @title
#' ggplot_modified_piper
#' @description
#' Function to create the base of the modified Piper plot as proposed by Appelo and Postma.
#' @return
#' This function returns the base of the modified Piper plot
#' @author
#' Oscar Garcia-Cabrejo \email{khaors@gmail.com}
#' @family modified_piper functions
#' @importFrom ggplot2 ggplot geom_segment
#' @export 
ggplot_modified_piper <- function(){
  p <- ggplot_piper()
  return(p)
}
#' @title 
#' add_lines_modified_piper
#' @description 
#' Auxiliary function to add the lines of the inmature and mature waters 
#' in a Giggenbach's geothermometer plot.
#' @param color A character string specifying the color of the lines separating 
#' mature and inmature waters.
#' @param Size A numeric value specifying the size of the temperature labels 
#' in the Giggenbach's geothermometer plot 
#' @return 
#' This function adds lines to define separate fields in the Giggenbach's 
#' geothermometer plot that has been previously created with the function 
#' ggplot_giggenbach
#' @author Oscar Garcia-Cabrejo, \email{khaors@gmail.com}
#' @family modified_piper functions
#' @importFrom ggplot2 geom_path geom_point geom_text
#' @export 
add_lines_modified_piper <- function(color = NULL, Size = NULL){
  # Define data.frames for Lines
  mixing.line.df <- data.frame(x = c(60, 150), y = c(103.9236, 121.2442))
  calcite.dissolution.df <- data.frame(x = c(110, 110), y = c(113, 70))
  calcite.precipitation.df <- data.frame(x = c(110, 110), y = c(113, 160))
  ion.exchange.df <- data.frame(x = c(110, 87), y = c(113, 150))
  ion.exchange.df1 <- data.frame(x = c(110, 137), y = c(113, 65))
  so4.reduction.df <- data.frame(x =c(110, 79), y = c(113, 129))
  #
  x <- NULL
  y <- NULL
  color1 <- "black"
  size1 <- 3
  #
  res <- list()
  if(!missing(color)){
    color1 <- color
  }
  #
  if(!missing(Size)){
    size1 <- Size
  }
  res[[1]] <- geom_line(aes(x = x, y = y), data = mixing.line.df, 
                        color = color1)
  res[[2]] <- geom_line(aes(x = x, y = y), data = calcite.dissolution.df, 
                        color = color1)
  res[[3]] <-  geom_line(aes(x = x, y = y), data = calcite.precipitation.df, 
                         color = color1)
  res[[4]] <-  geom_line(aes(x = x, y = y), data = ion.exchange.df, 
                         color = color1)
  res[[5]] <-  geom_line(aes(x = x, y = y), data = ion.exchange.df1, 
                         color = color1)
  res[[6]] <-  geom_line(aes(x = x, y = y), data = so4.reduction.df, 
                         color = color1)
  res[[7]] <-  annotate(geom = "label", x = 96, y = 110, label= "1", 
                        colour = color1, size = size1)
  res[[8]] <-  annotate(geom = "label", x = 110, y = 128, label = "2", 
                        colour = color1, size = size1)
  res[[9]] <-  annotate(geom = "label", x = 110, y = 90, label = "3", 
                        colour = color1, size = size1)
  res[[10]] <-  annotate(geom = "label", x = 98, y = 133, label = "4", 
                         colour = color1, size = size1)
  res[[11]] <-  annotate(geom = "label", x = 124, y = 89, label = "5", 
                         colour = color1, size = size1)
  res[[12]] <-  annotate(geom = "label", x = 96, y = 121, label = "6", 
                         colour = color1, size = size1)
  res[[13]] <-  annotate(geom = "label", x = 15, y = 150, 
                         label= "1: Mixing", colour = color1, size = size1)
  res[[14]] <-  annotate(geom = "label", x = 15, y = 142, 
                         label= "2: CaCO3 Precip.", 
                         colour = color1, size = size1)
  res[[15]] <-  annotate(geom = "label", x = 15, y = 134, 
                         label= "3: CaCO3 Dissol.", 
                         colour = color1, size = size1)
  res[[16]] <-  annotate(geom = "label", x = 15, y = 126, 
                         label= "4: Ion Exchange", 
                         colour = color1, size = size1)
  res[[17]] <-  annotate(geom = "label", x = 15, y = 118, 
                         label= "5: Ion Exchange", 
                         colour = color1, size = size1)
  res[[18]] <-  annotate(geom = "label", x = 15, y = 110, 
                         label= "6: SO4 Reduction", 
                         colour = color1, size = size1)
  #
  return(res)
}
#' @title
#' plot_modified_piper
#' @description
#' Function to create the modified Piper plot
#' @param x A geochemical_dataset object
#' @param measure A character variable specifying the type of measure to be used in the plot.
#' Currently the types supported include:
#' \itemize{
#' \item 'conc': concentrations
#' \item 'meql': miliequivalent
#' }
#' @param vars Character vector. Variables to use in the plot. In the case of the Durov plot, these variables
#' are already defined. Used only for compatibility with the plot function.
#' @param color Character variable that specifies the variable to color the data inside the plot.
#' @param Size Character variable that specifies the variable to define the size of the data inside the plot.
#' @param labels Character variable that specifies the name of the variable to assign text labels.
#' @param additional.args A list with additional arguments
#' @return
#' This function returns a ggplot2 object with the modified piper plot.
#' @author
#' Oscar Garcia-Cabrejo, \email{khaors@gmail.com}
#' @family modified_piper functions
#' @importFrom ggplot2 ggplot geom_point coord_fixed scale_color_gradientn scale_colour_gradientn scale_color_discrete aes_string annotate
#' @importFrom grDevices rainbow
#' @export
plot_modified_piper <- function(x, measure = c('conc', 'meql'),
                       vars = NULL, color = NULL,
                       Size = NULL, labels = NULL, 
                       additional.args = NULL){
  gdata <- x
  conc_ions <- colnames(gdata$dataset)
  meql_ions <- c("Ca", "Mg", "Na", "K", "HCO3", "CO3", "Cl", "SO4")
  if(class(gdata) != "geochemical_dataset"){
    stop('ERROR: A geochemical_dataset is required as input')
  }
  #  if(missing(vars) | is.null(vars)){
  #    stop('ERROR: Variable names must be specified to create a ternary diagram')
  #  }
  p <- ggplot_modified_piper() + add_lines_modified_piper() + 
    add_grid_lines_piper() + add_labels_piper()
  piper.df <- modified_piper_transform(gdata)
  cat_x <- NULL
  cat_y <- NULL
  an_x <- NULL
  an_y <- NULL
  d_x <- NULL
  d_y <- NULL
  fx <- NULL
  fy <- NULL
  y <- NULL
  # Labels
  ID.samples.df <- NULL
  if(!is.null(labels)){
    ID.samples.df <- data.frame(x = piper.df$d_x, y = piper.df$d_y,
                                labels = unname(gdata$dataset[labels]))
    #print(ID.samples.df)
  }
  #
  if(is.null(color)){
    if(is.null(Size)){
      p <- p + geom_point(aes(x = 100*cat_x, y = 100*cat_y), data = piper.df) +
        geom_point(aes(x = 100*an_x, y = 100*an_y), data= piper.df) +
        geom_point(aes(x = 100*d_x, y = 100*d_y), data = piper.df) +
        geom_segment(aes(x = 100*d_x, y = 100*d_y, xend = 100*fx, yend = 100*fy),
                     data = piper.df)
      if(!is.null(ID.samples.df)){
        p <- p +
          geom_text(aes(x = 100*x, y = 100*y, label = labels), data = ID.samples.df,
                    nudge_y = 2, size = 2)
      }
    }
    else{
      if(class(Size) == "numeric"){
        p <- p + geom_point(aes(x = 100*cat_x, y = 100*cat_y), data = piper.df,
                            size = Size) +
          geom_point(aes(x = 100*an_x, y = 100*an_y), data= piper.df,
                     size = Size) +
          geom_point(aes(x = 100*d_x, y = 100*d_y), data = piper.df,
                     size = Size) +
          geom_segment(aes(x = 100*d_x, y = 100*d_y, xend = 100*fx, yend = 100*fy),
                        data = piper.df) #+
      }
      else if(class(Size) == "character"){
        tmp <- gdata$dataset[Size]
        piper.df[Size] <- tmp[,1]
        p <- p + geom_point(aes(x = 100*cat_x, y = 100*cat_y, size = Size), data = piper.df) +
          geom_point(aes(x = 100*an_x, y = 100*an_y, size = Size), data = piper.df) +
          geom_point(aes(x = 100*d_x, y = 100*d_y, size = Size), data = piper.df)
        }
    }
  }
  else{
    tmp <- gdata$dataset[color]
    piper.df[color] <- tmp[,1]
    if(is.null(Size)){
      p <- p + geom_point(aes_string(x = "100*cat_x", y = "100*cat_y", color = color),
                          data = piper.df, size = 3) +
        geom_point(aes_string(x = "100*an_x", y = "100*an_y", color = color),
                    data= piper.df, size = 3) +
        geom_point(aes_string(x = "100*d_x", y = "100*d_y", color = color),
                   data = piper.df, size = 3) + 
        geom_segment(aes(x = 100*d_x, y = 100*d_y, xend = 100*fx, yend = 100*fy),
                     data = piper.df)
    }
    else{
      if(class(Size) == "numeric"){
        p <- p + geom_point(aes_string(x = "100*cat_x", y = "100*cat_y",
                                       color = color),
                            data = piper.df, size = Size) +
          geom_point(aes_string(x = "100*an_x", y = "100*an_y", color = color),
                     data= piper.df, size = Size) +
          geom_point(aes_string(x = "100*d_x", y = "100*d_y", color = color),
                     data= piper.df, size = Size) +
          geom_segment(aes_string(x = "100*d_x", y = "100*d_y", xend = "100*fx",
                                  yend = "100*fy", color = color), data = piper.df) #+
      }
      else if(class(Size) == "character"){
        tmp <- gdata$dataset[Size]
        piper.df[Size] <- tmp[,1]
        p <- p + geom_point(aes_string(x = "100*cat_x", y = "100*cat_y",
                                       color = color, size = Size),
                            data = piper.df) +
          geom_point(aes_string(x = "100*an_x", y = "100*an_y",
                                color = color, size = Size),
                     data = piper.df) +
          geom_point(aes_string(x = "100*d_x", y = "100*d_y",
                                color = color, size = Size),
                     data = piper.df) +
          geom_segment(aes_string(x = "100*d_x", y = "100*d_y", xend = "100*fx",
                                  yend = "100*fy", color = color),
                       data = piper.df)#+
      }
    }
  }
  #
  p <- p + coord_fixed()
  #
  if(!is.null(color)){
    tmp <- gdata$dataset[color]
    if(class(tmp[,1]) == "numeric"){
      p <- p + scale_colour_gradientn(colours = rainbow(10))
    }
    else if(class(tmp[,1]) == "factor"){
      p <- p + scale_color_discrete()
    }
  }
  #
  return(p)
}
#' @title
#' classification_reactions_piper_mod
#' @description
#' Function to calculate the contribution of each chemical reaction to the chemical composition
#' of a given sample
#' @param dx A numeric vector with the increments in x
#' @param dy A numeric vector with the increments in y
#' @return
#' This function returns a matrix with the given contribution of each type of chemical reaction
#' @author
#' Oscar Garcia-Cabrejo, \email{khaors@gmail.com}
#' @family modified_piper functions
#' @export
classification_reactions_piper_mode <- function(dx, dy){
  #
  V <- matrix(0.0, nrow = 2, ncol = 6)
  V[1:2,1] <- c(5.19, 1)# Mixing
  V[1:2,2] <- c(-23, 37)# Ionic exchange 1
  V[1:2,3] <- c(27, -48) # Ionic exchange 2
  V[1:2,4] <- c(0, 1) # CaCO3 Precipitation
  V[1:2,5] <- c(0, -1) # CaCO3 Dissolution
  V[1:2,6] <- c(-31, 16) # SO4 reduction
  FF <- t(V)%*%V
  FF1 <- cbind(FF, matrix(1, nrow = 6, ncol = 1))
  FF2 <- rbind(FF1, matrix(1, nrow = 1, ncol = 7))
  AA <- FF2
  AA[7,7] <- 0
  #
  ndat <- length(dx)
  results <- matrix(0.0, nrow = ndat, ncol = 6)
  for(i in 1:ndat){
    bb <- t(V)%*%matrix(c(dx[i], dy[i]), nrow = 2, ncol = 1)
    bb <- rbind(bb, 1)
    current.contr <- solve(AA + 1e-6*diag(7), bb)
    results[i,] <- current.contr[1:6]
  }
  return(results)
}
