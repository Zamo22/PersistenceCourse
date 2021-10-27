import UIKit

class TodoListViewController: UITableViewController {

    var items: [TodoItem] = []
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let fetchedItems = defaults.array(forKey: "todoItemsArray") as? [TodoItem] {
            items = fetchedItems
        }
        // Do any additional setup after loading the view.
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
        self.defaults.set(self.items, forKey: "todoItemsArray")
        tableView.cellForRow(at: indexPath)?.accessoryType = items[indexPath.row].done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Button actions
    @IBAction func addNewItemTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { _ in
            let newItem = TodoItem(title: textField.text ?? "", done: false)
            self.items.append(newItem)
            self.defaults.set(self.items, forKey: "todoItemsArray")

            self.tableView.reloadData()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

