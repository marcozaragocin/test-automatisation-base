Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def urlCharacters = 'https://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'

  Scenario: Verificar que un endpoint público responde 200
    Given url 'https://httpbin.org/get'
    When method get
    Then status 200

  Scenario: T-API-VALIDAR QUE EN LA LISTA DE USUARIOS NO LLEGUE NULA EL ID NO SEA NULL Y EL NOMBRE SEA sTRING
    Given url urlCharacters
    When method GET
    Then status 200
    And match response != null
    And match response contains deep { id: '#notnull', name: '#string' }

  Scenario: T-API-CREAR NUEVO PERSONAJE
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "SP",
        "alterego": "mz",
        "description": "MZ",
        "powers": ["fury", "EAT"]
      }
      """
    When method post
    Then status 201
    And match response.name == 'SP'
    And match response.alterego == 'mz'
    And match response.powers[0] == 'fury'

  Scenario: T-API-VALIDACION USUARIO SI EXISTE
    Given url urlCharacters
    Given path '200'
    When method get
    Then status 200
    And match response.id == 200
    And match response.name == '#string'

  Scenario: T-API-USUARIO PERSONAJE NO EXISTE ERROR 404
    Given url urlCharacters
    Given path '-999'
    When method GET
    Then status 404
    And match response != null
    And match response != null
    And match response contains { error: '#notnull' }

  Scenario: T-API-CREAR NUEVO PERSONAJE YA EXISTE
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "SP",
        "alterego": "mz",
        "description": "MZ",
        "powers": ["fury", "EAT"]
      }
      """
    When method post
    Then status 400
    And match response contains { error: '#notnull' }

  Scenario: T-API-ACTUALIZAR PERSONAJE POR ID
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/2023'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "CHESPIRITO_1",
        "alterego": "roberto",
        "description": "Personaje actualizado",
        "powers": ["comedia", "ingenio"]
      }
      """
    When method put
    Then status 200
    And match response.name == 'CHESPIRITO_1'
    And match response.alterego == 'roberto'
    And match response.description == 'Personaje actualizado'
    And match response.powers contains 'comedia'

  Scenario: T-API-ELIMINAR PERSONAJE POR ID
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/2612'
    When method delete
    Then status 204

