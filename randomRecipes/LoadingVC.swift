
import UIKit
import CoreData

class LoadingVC: UIViewController {
    var delegate: fillerProtocal?
    var calledApi = ApiCaller()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        getRecipe()

    }
    func getRecipe(){
        print("Got Here")
        let dispatchGroup = DispatchGroup()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print(appDelegate, #line, #function)
        let context = appDelegate.persistentContainer.viewContext
        print(context, #line, #function, Date())
        for _ in 1...20 {
            dispatchGroup.enter()
            calledApi.getRecipe(completion: {
                (Recipe) in
                print(Recipe)
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
                do {
                    try context.save()
                    print("We Saved it")
                }
                catch {
                    print("sorry")
                }
                dispatchGroup.leave()
            })
        }
        print(#line, #function, "<<<")
       // performSegue(withIdentifier: "loadingSegue" , sender: nil)
        print(#line, #function, "<<<")
        print(Thread.current, #line, "The thread baby!")
        dispatchGroup.notify(queue: .main) {
//            print("Both functions complete 👍")
         self.performSegue(withIdentifier: "loadingSegue" , sender: nil)
        }
    }
}
