
import UIKit
import CoreData

class LoadingVC: UIViewController {
     var copiesArray = [String]()
    var delegate: fillerProtocal?
    var calledApi = ApiCaller()
    var fetchData = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ConnectionCheck.isConnectedToNetwork() {
            print("we are good")
        } else {
            let alert = UIAlertController(title: "The Search Bar is empty", message: "Please enter Text" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        deleteRecipes()
        getRecipe()

    }
    
    func getRecipe(){
        var copiesArray = [String]()
        let dispatchGroup = DispatchGroup()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        for _ in 1...15 {
            dispatchGroup.enter()
            calledApi.getRecipe(completion: {
                (Recipe) in
                if !copiesArray.contains(Recipe._recipeTitle) {
                copiesArray.append(Recipe._recipeTitle)
                let entity = NSEntityDescription.entity(forEntityName: "Recipes", in: context)!
                let newRecipe = NSManagedObject(entity: entity, insertInto: context)
                let recipeImageURL = URL(string: Recipe._recipeImage)
                let recipePictureData = NSData(contentsOf: recipeImageURL!)
                newRecipe.setValue(recipePictureData, forKey: "recipeImage")
                newRecipe.setValue(Recipe._recipeTitle, forKey: "recipeTitle")
                newRecipe.setValue(Recipe._recipeType, forKey: "recipeType")
                newRecipe.setValue(Recipe._ingredientsArray, forKey: "recipeIngredients")
                newRecipe.setValue(Recipe._ingredientMeasurementsArray, forKey: "recipeIngredientMeasurements")
                newRecipe.setValue(Recipe._recipeOrigin, forKey: "recipeOrigin")
                newRecipe.setValue(Recipe._favoriteLetter, forKey: "favoriteLetter")
                newRecipe.setValue(Recipe.favorited, forKey: "favorited")
                newRecipe.setValue(Recipe._recipeInstructions, forKey: "recipeInstructions")
                do {
                    try context.save()
                }
                catch {
                    print("sorry")
                }
                }
                dispatchGroup.leave()
            })
        }

        dispatchGroup.notify(queue: .main) {
        self.performSegue(withIdentifier: "loadingSegue" , sender: nil)
        }
    }
    
    func deleteRecipes() -> Void {
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [NSManagedObject]
        
        for object in resultData {
            if object.value(forKey: "favorited") as? Bool == false {
                moc.delete(object)
            }
        }
        
        do {
            try moc.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    
    // MARK: Get Context
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
