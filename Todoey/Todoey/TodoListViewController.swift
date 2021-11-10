import UIKit

class TodoListViewController: UITableViewController {

    var items: [TodoItem] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItemsFromStorage()
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
            let newItem = TodoItem(title: textField.text ?? "", done: false)
            self.items.append(newItem)
            self.updateItemsInStorage()
            self.tableView.reloadData()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func updateItemsInStorage() {
        let encoder = PropertyListEncoder()
        guard let url = dataFilePath else { return }
        do {
            let data = try encoder.encode(items)
            try data.write(to: url)
        } catch let err {
            print("Error encoding item array: \(err)")
        }
    }

    func loadItemsFromStorage() {
        guard let url = dataFilePath else { return }
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: url) {
            do {
                items = try decoder.decode([TodoItem].self, from: data)
            } catch let error {
                print("Error decoding: \(error)")
            }

        }
        tableView.reloadData()
    }

}

