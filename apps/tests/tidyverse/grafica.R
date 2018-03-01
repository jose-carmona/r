# Partimos de te_sprint_actual
#   - left join entre peticiones del sprint e imputaciones de tiempo a esas peticiones

primer_dia <- as.Date('2018-02-19', '%Y-%m-%d')

# trabajamos sobre w para salvaguardar la información de partida
w <- te_sprint_actual

# Buscamos las estimaciones. Sacamos id, imprevisto y estimado. Si no hay estimación, consideramos 0. Ordenado por id
estimaciones <- w %>% 
                select( id, imprevisto, estimated_hours  ) %>% 
                mutate(estimated_hours = ifelse(is.na(estimated_hours), 0, estimated_hours)) %>%
                distinct() %>% 
                arrange(id)

# suma de todas las imputaciones anteriores al periodo estudiado
imputaciones_iniciales <- w %>% filter( hours > 0, spent_on < primer_dia) %>% group_by(id) %>% summarise( horas_iniciales = sum(hours))

# pendiente incial
pendiente_inicial <- left_join( estimaciones, imputaciones_iniciales) %>% 
                     mutate( horas_iniciales = ifelse( is.na(horas_iniciales), 0, horas_iniciales) )

pendiente_inicial$pendiente_inicio <- pendiente_inicial$estimated_hours - pendiente_inicial$horas_iniciales

pendiente_inicial$pendiente_inicio <- sapply( pendiente_inicial$pendiente_inicio, function(x) ifelse( x < 0 || is.na(x),  0 , x ) )

# agrupamos los imputado por id y fecha
imputaciones <- w %>% filter( hours > 0, spent_on >= primer_dia) %>% group_by(id,spent_on) %>% summarise( horas = sum(hours))

# cada petición, con sus imputaciones
peticiones_imputaciones <- left_join( estimaciones, imputaciones )

# matriz de peticiones / imputaciones por día
matriz <- dcast( peticiones_imputaciones, id ~ spent_on, value.var = "horas", fill=0)

# calulamos el pendiente de cada petición día a día
p <- pendiente_inicial$pendiente_inicio

for( n in names(matriz)) {
  if(n != "id") {
    matriz[n] <- p - matriz[n]
    matriz[n] <- sapply( matriz[n], function(x) ifelse( x < 0,  0 , x ) )
    p <- matriz[n]
  }
}
  

# Construimos el Burndown

burndown <- data.frame(pendiente = colSums(matriz[,c(2:(ncol(matriz)-1))]))

ggplot(burndown, aes( x = as.Date(rownames(burndown)), y = pendiente)) +
  geom_line( aes(group = 1)) + 
  geom_point() +
  xlim( c(primer_dia,ultimo_dia) )

        
