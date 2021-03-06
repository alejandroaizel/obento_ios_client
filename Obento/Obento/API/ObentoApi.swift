//
//  ObentoApi.swift
//  Obento
//
//  Created by Víctor Palma on 29/3/22.
//

import Foundation

class ObentoApi {
    
    // Endpoints data
    struct Endpoint {
        // Base URL
        static let baseURL = "http://13.37.225.162:8000"
        //static let baseURL = "http://localhost:8000"

        // Resources endpoints
        static let recipe = "\(baseURL)/recipes"
        static let recipeOCR = "\(baseURL)/recipe_ocr"
        static let recipeCategories = "\(baseURL)/recipe_categories"
        static let ingredient = "\(baseURL)/ingredients"
        static let menu = "\(baseURL)/menus"
        static let exportMenu = "\(baseURL)/export_menu"
        static let user = "\(baseURL)/user"
    }

    public init() {}

    // GENERIC_METHODS //
    
    // Get
    private static func get<T: Decodable>(
        from url: URL,
        body: [String:Any] = [:]
    ) async throws -> T {
        // Decoder and session for request
        let decoder = JSONDecoder()
        
        // Create URL Request
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        
        // Check body data
        if (!body.isEmpty) {
            do {
                request.httpBody = try JSONSerialization.data(
                    withJSONObject: body, options: []
                )
            } catch {
                return Void() as! T
            }
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check possible errors
        guard (response as? HTTPURLResponse)!.statusCode <= 300
        else {
            return Void() as! T
        }
        
        // Decode data as T generic type
        let result = try decoder.decode(T.self, from: data)
        return result
    }
    
    private static func getAll<T: Decodable>(
        from url: URL,
        data: [String:Any] = [:]
    ) async throws -> [T] {
        // Decoder for request
        let decoder = JSONDecoder()

        // Create URL Request
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        
        // Check body data
        if (!data.isEmpty) {
            do {
                request.httpBody = try JSONSerialization.data(
                    withJSONObject:data)
            } catch {
                return []
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check possible errors
        guard (response as? HTTPURLResponse)!.statusCode <= 300
        else {
            return []
        }
        
        // Decode data as T generic type
        let result = try decoder.decode([T].self, from: data)
        
        return result
    }
    
    // Post-Put
    private static func post<T: Encodable>(
        from url: URL,
        data: T,
        update: Bool = false
    ) async throws -> [String:Any]? {
        // Create request and encoder
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        
        // Method, headers and body
        if update {
            // Update content
            request.httpMethod = "PUT"
        } else {
            // Create new content
            request.httpMethod = "POST"
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(data)
        
        // Make the request
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)!.statusCode <= 300
        else {
            return nil
        }
        
        // Parse the result (generic JSON)
        let result = try JSONSerialization.jsonObject(
            with: data,
            options: .fragmentsAllowed
        ) as! [String: Any]

        return result
    }
        
    // Delete
    private static func delete(
        from url: URL
    ) async throws -> [String:Any]? {
        // Create request and encoder
        var request = URLRequest(url: url)
        
        // Method, headers and body
        request.httpMethod = "DELETE"
        
        // Make the request
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)!.statusCode <= 300
        else {
            return nil
        }
        
        // Parse the result (generic JSON)
        let result = try JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        ) as! [String: Any]

        return result
    }
    
    // ENDPOINT_METHODS
    
    // Recipes
    
    /**
    Return recipe by ID

    - parameter id: Int.
    - returns: Recipe, nil if recipe not exists
    */
    public static func getRecipe(id: Int) async -> Recipe? {
        guard let url = URL(string: "\(Endpoint.recipe)/\(id)")
        else {
            return nil
        }
        do {
            let result = try await ObentoApi.get(from: url) as Recipe
            return result
        } catch {
            return nil
        }
    }
    
    public static func getRecipes() async -> [Recipe] {
        guard let url = URL(string: "\(Endpoint.recipe)")
        else {
            return []
        }
        do {
            let result = try await ObentoApi.getAll(from: url) as [Recipe]
            return result
        } catch {
            return []
        }
    }
    
    /**
    Add new recipe to Obento

    - parameter recipe: Recipe.
    - returns: ID of recipe created, -1 otherwise
    */
    public static func postRecipe(recipe: Recipe) async -> Int {
        guard let url = URL(string: "\(Endpoint.recipe)")
        else {
            return -1
        }
        do {
            let result = try await ObentoApi.post(from: url, data: recipe)
            // Check data
            if let recipe_id = result?["id"] {
                return recipe_id as! Int
            }
        } catch {
            return -1
        }
        return -1
    }
    
    public static func postRecipeOCR(imageData: Data) async -> OCRData? {
        guard let url = URL(string: "\(Endpoint.recipeOCR)")
        else {
            return nil
        }
        do {
            let result = try await ObentoApi.post(
                from: url, data: ["image": imageData]
            )
            // Check data
            if result != nil {
                // List of ingredients
                var ingList: [Ingredient] = []
                for ingredient in result!["ingredients"] as! [[String: Any]] {
                    ingList.append(Ingredient(
                        ingredient_id: ingredient["ingredient_id"] as! Int,
                        ingredient_quantity: Float(ingredient["quantity"] as! String)!
                        )
                    )
                }
                // Create object
                let ocrData: OCRData = OCRData(
                    ingredients: ingList,
                    steps: result!["steps"] as! [String]
                )
                return ocrData
            }
        } catch {
            return nil
        }
        return nil
    }
    
    /**
    Delete an existing recipe in Obento

    - parameter id of recipe to be deleted,
    - returns: true if delete, false otherwise
    */
    public static func deleteRecipe(id: Int) async -> Bool {
        guard let url = URL(string: "\(Endpoint.recipe)/\(id)")
        else {
            return false
        }
        do {
            // Make request
            let result = try await ObentoApi.delete(from: url)
            // Check data
            if (result != nil) {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    /**
    Delete an existing recipe in Obento

    - parameter id of recipe to be deleted,
    - returns: true if delete, false otherwise
    */
    public static func getRecipeCategories() async -> [String] {
        guard let url = URL(string: "\(Endpoint.recipeCategories)")
        else {
            return []
        }
        do {
            // Make request
            let result: [RecipeCategory] = try await ObentoApi.getAll(
                from: url
            ) as [RecipeCategory]
            
            // Prepare array with categories
            if (!result.isEmpty) {
                var categories: [String] = []
                
                for category in result {
                    categories.append(category.name)
                }
                
                return categories
            } else {
                return []
            }
        } catch {
            return []
        }
    }

    public static func getRecipesByCategory(category: Int) async -> [Recipe] {
        guard let url = URL(string: "\(Endpoint.recipe)?category=\(category)")
        else {
            return []
        }
        do {
            // Make request
            let result: [Recipe] = try await ObentoApi.getAll(
                from: url
            ) as [Recipe]
            return result
        } catch {
            return []
        }
    }
    
    /**
    Return recipe by user, date and time from Obento

    - parameter id: menu ID.
    - parameter userId: user ID.
    - parameter date: recipe time
    - parameter isLunch: true if time is lunch, false otherwise
    - returns: Menu with given ID, nil otherwise
    */
    public static func getFeaturedRecipe(
        id: Int,
        userId: Int,
        date: String,
        isLunch: Bool
    ) async -> Recipe? {
        guard let url = URL(string: "\(Endpoint.menu)/\(id)") else {
            return nil
        }
        do {
            // Prepare body request
            let body = [
                "user": userId,
                "date": date,
                "is_lunch": isLunch
            ] as [String : Any]
            
            // Make request
            let result: Recipe = try await ObentoApi.get(
                from: url, body: body
            ) as Recipe
            return result
        } catch {
            return nil
        }
    }

    /*
    public func getRecipesByCategory() -> Recipe {}
    public func getRecipes() -> Recipe {}
    public func updateRecipe() -> Recipe {}
    */

    // Menus
    
    /**
    Return menu from obento

    - parameter id: menu ID.
    - returns: Menu with given ID, nil otherwise
    */
    public static func getMenu(userId: Int) async -> [MenuItem] {
        guard let url = URL(string: "\(Endpoint.menu)?user=\(userId)") else {
            return []
        }
        do {
            // Make request
            let result: [MenuItem] = try await ObentoApi.get(
                from: url
            ) as [MenuItem]
            return result
        } catch {
            return []
        }
    }

    
    /**
    Get all menus from obento

    - returns: Menu array with all menus, empty array otherwise
    */
    public static func getMenus() async -> [MenuItem] {
        guard let url = URL(string: "\(Endpoint.menu)") else {
            return []
        }
        do {
            // Make request
            let result: [MenuItem] = try await ObentoApi.getAll(
                from: url
            ) as [MenuItem]
            return result
        } catch {
            return []
        }
    }

    /**
    Add new menu to Obento

    - parameter menu: Menu.
    - returns: ID of menu created, -1 otherwise
    */
    public static func postMenuSimple(menu: MenuSimple) async -> Int {
        guard let url = URL(string: "\(Endpoint.menu)") else {
            return -1
        }
        do {
            let result = try await ObentoApi.post(from: url, data: menu)
            // Check data
            if let menu_id = result?["id"] {
                return 0
            }
        } catch {
            return -1
        }
        return -1
    }
    
    public static func postMenuComplex(menu: MenuComplex) async -> Int {
        guard let url = URL(string: "\(Endpoint.menu)") else {
            return -1
        }
        do {
            let result = try await ObentoApi.post(from: url, data: menu)
            // Check data
            if let menu_id = result?["id"] {
                return 0
            }
        } catch {
            return -1
        }
        return -1
    }
    
    
    public static func exportMenu(menu: WeeklyMenu) async -> Bool {
        guard let url = URL(string: "\(Endpoint.exportMenu)") else {
            return false
        }
        do {
            // Create request and encoder
            var request = URLRequest(url: url)
            let encoder = JSONEncoder()
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! encoder.encode(menu)
            request.httpMethod = "POST"
            
            // Make the request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)!.statusCode <= 300
            else {
                return false
            }
            
            // Prepare filesystem
            let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0]
            
            let fileName = documentDirectory.appendingPathComponent("obento_menu.ics")
            try data.write(to: fileName)
        } catch {
            return false
        }
        return true
    }
    
    /**
    Delete menu from Obento

    - parameter id: ID of menu.
    - returns: true if deleted, false otherwise
    */
    public static func deleteMenu(id: Int) async -> Bool {
        guard let url = URL(string: "\(Endpoint.menu)/\(id)") else {
            return false
        }
        do {
            // Make request
            let result = try await ObentoApi.delete(from: url)
            // Check data
            if (result != nil) {
                return true
            }
        } catch {
            return false
        }
        return false
    }

    /*
    public func postMenu(ocr: Bool) -> Menu {}
    public func updateMenu() -> Menu {}
    */
    
    // Ingredient
    
    /**
    Return all ingredients from Obento

    - returns: Ingredient array with all ingredients
    */
    public static func getIngredients() async -> [Ingredient] {
        guard let url = URL(string: "\(Endpoint.ingredient)")
        else {
            return []
        }
        do {
            // Make request
            let result: [Ingredient] = try await ObentoApi.getAll(
                from: url
            ) as [Ingredient]
            return result
        } catch {
            return []
        }
    }

    /*
    public func getIngredient() -> Ingredient {}
    public func getIngredientByCategory() -> Ingredient {}
    public func postIngredient() -> Ingredient {}
    public func updateIngredient() -> Ingredient {}
    public func deleteIngredient() -> Ingredient {}
    */
    
    // User
    
    /**
    Returns all recipes of the given user

    - parameter id: ID user to return the recipes.
    - returns: Recipe array with all user recipes
    */
    public static func getRecipesByUser(userId: Int) async -> [Recipe] {
        guard let url = URL(string: "\(Endpoint.user)/\(userId)/recipes")
        else {
            return []
        }
        do {
            // Make request
            let result: [Recipe] = try await ObentoApi.getAll(
                from: url
            ) as [Recipe]
            return result
        } catch {
            return []
        }
    }

    // Score
    public static func updateRateByUserAndRecipe(
        userId: Int,
        recipeId: Int,
        rate: Int
    ) async -> Bool {
        //TODO: endpoint isn't working
        return false
    }
    public static func postRateByRecipe(
        recipeId: Int,
        rate: Int
    ) async -> Bool {
        //TODO: endpoint isn't working
        return false
    }
    
    // Shopping List
    
    public static func getShoppingListByUser(
        userId: Int
    ) async -> ShoppingList? {
        guard let url = URL(string: "\(Endpoint.user)/\(userId)/shopping_list")
        else {
            return nil
        }
        do {
            // Make request
            let result: ShoppingList = try await ObentoApi.get(
                from: url
            ) as ShoppingList
            return result
        } catch {
            return nil
        }
    }
    
    public static func updateShoppingListByUser(
        userId: Int,
        ingredient: Ingredient
    ) async -> Bool {
        guard let url = URL(string: "\(Endpoint.user)/\(userId)/shopping_list")
        else {
            return false
        }
        do {
            // Make request
            try await ObentoApi.post(
                from: url,
                data: ingredient,
                update: true
            )
            return true
        } catch {
            return false
        }
    }
    
    public static func updateShoppingListByRecipe(
        userId: Int,
        recipeId: Int
    ) async -> Bool {
        guard let url = URL(string: "\(Endpoint.user)/\(userId)/shopping_list")
        else {
            return false
        }
        do {
            // Make request
            try await ObentoApi.post(
                from: url,
                data: ["recipe_id": recipeId],
                update: true
            )
            return true
        } catch {
            return false
        }
    }
}
