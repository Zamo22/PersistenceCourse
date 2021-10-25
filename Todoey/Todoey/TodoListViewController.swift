import UIKit

class TodoListViewController: UITableViewController {

    var items = ["Eat food", "Work", "Study"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let existingAccessory = tableView.cellForRow(at: indexPath)?.accessoryType ?? .none
        tableView.cellForRow(at: indexPath)?.accessoryType = existingAccessory == .none ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Button actions
    @IBAction func addNewItemTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            self.items.append(textField.text ?? "")
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

