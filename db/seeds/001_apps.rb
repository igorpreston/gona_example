App.find_or_create_by(template: 'square') do |app|
  app.published = true
  app.name = 'Square POS'
  app.description = "Our integration with Square POS simplifies operations by automatically syncing locations, items, and pushing orders directly to the POS. This efficient connection streamlines transaction management and enhances overall business efficiency with Square's robust POS system."
end

App.find_or_create_by(template: 'clover') do |app|
  app.published = true
  app.name = 'Clover POS'
  app.description = "The integration with Clover POS facilitates automatic synchronization of locations and items, along with smooth order transfer to the POS system. It enhances operational efficiency and simplifies transaction management by utilizing Clover's advanced POS features."
end
