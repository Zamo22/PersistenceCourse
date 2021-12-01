import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var items: [Item] = []
    var selectedCategory: TodoCategory? {
        didSet {
            loadItemsFromStorage()
        }
    }

    var context: NSManagedObjectContext! {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done.toggle()
        updateItemsInStorage()
        tableView.cellForRow(at: indexPath)?.accessoryType = items[indexPath.row].done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Button actions
    @IBAction func addNewItemTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { _ in
            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? ""
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.items.append(newItem)
            self.updateItemsInStorage()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func updateItemsInStorage() {
        do {
            try context.save()
        } catch let error {
            print(error)
        }
        tableView.reloadData()
    }

    func loadItemsFromStorage(using request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPred = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory?.name ?? "")

        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPred])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPred
        }

        do {
            items = try context.fetch(request)
        } catch let err {
            print(err)
        }
        tableView.reloadData()
    }

}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItemsFromStorage(using: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItemsFromStorage()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
