import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories: [TodoCategory] = []

    var context: NSManagedObjectContext! {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }


    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { _ in
            let newCategory = TodoCategory(context: self.context)
            newCategory.name = textField.text ?? ""
            self.categories.append(newCategory)
            self.updateCategories()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func updateCategories() {
        do {
            try context.save()
        } catch let error {
            print(error)
        }
        tableView.reloadData()
    }

    func loadCategories(using request: NSFetchRequest<TodoCategory> = TodoCategory.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch let err {
            print(err)
        }
        tableView.reloadData()
    }

}

// MARK: - Table view delegates
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedCategory = categories[indexPath.row]
        }
    }
}

// MARK: - Data manipulation
extension CategoryViewController {

}
