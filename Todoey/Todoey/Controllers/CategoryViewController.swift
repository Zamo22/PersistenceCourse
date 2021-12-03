import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()

    var categories: Results<TodoCategory>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }


    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { _ in
            let newCategory = TodoCategory()
            newCategory.name = textField.text ?? ""
            self.save(category: newCategory)
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - Table view delegates
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedCategory = categories?[indexPath.row]
        }
    }
}

// MARK: - Data manipulation
extension CategoryViewController {
    func save(category: TodoCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch let error {
            print(error)
        }
        tableView.reloadData()
    }

    func loadCategories() {
        categories = realm.objects(TodoCategory.self)
        tableView.reloadData()
    }
}
