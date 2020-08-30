//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Douglas Frari on 8/24/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit
import CoreData

// esse tipo de classe oferece mais recursos para monitorar os dados


class ConsolesTableViewController: UITableViewController {

    var fetchedResultController:NSFetchedResultsController<Console>!
    var console: Console?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        loadConsoles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       // se ocorrer mudancas na entidade Console, a atualização automatica não irá ocorrer porque nosso NSFetchResultsController esta monitorando a entidade Game. Caso tiver mudanças na entidade Console precisamos atualizar a tela com a tabela de alguma forma: reloadData :)
       tableView.reloadData()
        loadConsoles()
    }
    
    func loadConsoles() {

        // Coredata criou na classe model uma funcao para recuperar o fetch request
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()

        // definindo criterio da ordenacao de como os dados serao entregues
        let consoleTitleSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [consoleTitleSortDescriptor]

        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self

        do {
             try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }

        
        
//
//      ConsolesManager.shared.loadConsoles(with: context)
//        tableView.reloadData()
    }
    
    
    

    
    
    
    
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      let count = fetchedResultController?.fetchedObjects?.count ?? 0
      return count


        
        
      // return ConsolesManager.shared.consoles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConsoleTableViewCell
        guard let console = fetchedResultController.fetchedObjects?[indexPath.row] else {
           return cell
        }

        cell.prepare(with: console)
        return cell

        
        
        
        
        
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let console = ConsolesManager.shared.consoles[indexPath.row]
//        cell.textLabel?.text = console.name
//        // podemos setar uma imagem (se necessario)
//        cell.imageView?.image = UIImage(named: "console")
//        return cell
        
    }
    
    // MARK: - Table view delegate
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//       let console = ConsolesManager.shared.consoles[indexPath.row]
//       showAlert(with: console)
//        
//        // deselecionar atual cell
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            ConsolesManager.shared.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//
//        //
//        if segue.identifier! == "ConsoleSegue" {
//            print("gameSegue")
//            let vc = segue.destination as! ConsoleViewController
//            vc.console = ConsolesManager.shared.consoles[tableView.indexPathForSelectedRow!.row]
//            }
//
//        }
//
//    }
    
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier! == "ConsoleSegue"{
            print("consoleSegue")
        let vc = segue.destination as! ConsoleViewController
        
        if let consoles = fetchedResultController.fetchedObjects {
            vc.console = consoles[tableView.indexPathForSelectedRow!.row]
        }
        }
    }
    
    
    
    
    
    
//    @IBAction func addConsole(_ sender: Any) {
//        print("add console ...")
//
//        //showAlert(with: nil)
//    }
    
    
    func showAlert(with console: Console?) {
        let title = console == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + " plataforma", message: nil, preferredStyle: .alert)

        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Nome da plataforma"

            if let name = console?.name {
                textField.text = name
            }
        })

        alert.addAction(UIAlertAction(title: title, style: .default, handler: {(action) in
            let console = console ?? Console(context: self.context)
            console.name = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadConsoles()
            } catch {
                print(error.localizedDescription)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor(named: "second")

        present(alert, animated: true, completion: nil)
    }
    

} // fim da classe


extension ConsolesTableViewController: NSFetchedResultsControllerDelegate {
   
    // sempre que algum objeto for modificado esse metodo sera notificado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
       
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
    }
}
