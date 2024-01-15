//
//  HomeViewController.swift
//  Movie-App
//
//  Created by ayman on 04/01/2024.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import Lottie
import DropDown
import Combine

class HomeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var menue : DropDown?
    
    var cancellable : Set<AnyCancellable> = []
    private var animationView: LottieAnimationView?
    private let viewModel = HomeVM()
    private let disposeBag = DisposeBag()
    let sections = BehaviorSubject<[String]>(value: ["Section 1", "Section 2", "Section 3"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup loadingindactor
        self.isLoadingIndicatorAnimating = true
        
        title = viewModel.sortOption.rawValue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        //setup the menu popdowm
        menue = self.setupDropDownMenu()
        //seup collettion
        setupCollection()
        // setup data source
        bindCollectionView()
    }
    
    //MARK: - set up the collection DataSource
    // bind the observed movie list to collection view and configure the cell
    func bindCollectionView(){
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
       //set up the cells
        viewModel.MoviesData.bind(to: collectionView.rx.items(cellIdentifier: "cell",cellType: HomeCollectionViewCell.self)){
            
            index , model ,cell in
            if   self.isLoadingIndicatorAnimating == true {
                self.isLoadingIndicatorAnimating = false
            }
            
            cell.config(with: model)
            
        }.disposed(by: disposeBag)
        
        // select amovie and navgate to details View
        collectionView.rx.modelSelected(result.self).subscribe { model  in
            let  viewModel = MovieDetailsVM(MovieElement: model)
            
            if let MovieDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as? MovieDetailsVC{
                MovieDetailsVC.viewModel = viewModel
                self.navigationController?.pushViewController(MovieDetailsVC, animated: true)
            }
            else{
                print("cant create the VC")
            }
            
        }.disposed(by: disposeBag)
        
        // detect you reached to end of the page and load the next page
        collectionView.rx.willDisplayCell.subscribe(onNext: { [weak self ] cellInfo in
            
            guard let strongSelf = self else {return}
            let lastcell = strongSelf.collectionView.numberOfItems(inSection: 0) - 1
            if cellInfo.at.row == lastcell{
                self?.isLoadingIndicatorAnimating = true
                strongSelf.animateReload()
                if  (self?.viewModel.currantPage)! < self?.viewModel.totaPages ?? 1{
                    self?.viewModel.currantPage += 1
                    print(self!.viewModel.currantPage)
                    self?.viewModel.fetchMovies(page: self?.viewModel.currantPage ?? 1)
                }}
        }).disposed(by: disposeBag)
        
        // detect if there is any error
        viewModel.$MoviesFetchError.receive(on: DispatchQueue.main).sink { [weak self] error  in
            if let error2 = error {
                self!.showAlert(error:error2)
            }
        }.store(in: &cancellable)
      

        viewModel.fetchMovies()
        
    }
    
    
    
    // animated reload
    private func animateReload() {
        
        UIView.transition(with: self.collectionView, duration:3 , options: .transitionCurlUp, animations: {
        }, completion: nil)
    }
    
    
    
    func setupCollection(){
        // setup collection
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
        //setupCollectionLayout
        let  screenSize = UIScreen.main.bounds
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let mainWindow = windowScene?.windows.first
        // get the safe area from bottom and top
        guard let safeAreaTop  =  mainWindow?.safeAreaInsets.top,
              let safeAreaBottom  =  mainWindow?.safeAreaInsets.bottom
        else{return}
        
        let  screenWidth = screenSize.width
        let  screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenWidth)/2, height: (screenHeight-safeAreaTop-safeAreaBottom - 5.0 )/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        collectionView!.collectionViewLayout = layout
        
    }
    
    // sort Button Selcection
    @IBAction func SortButtonClicked(_ sender: Any) {
        
        menue!.show()
        //    print(menue?.selectedItem)
        
        menue?.selectionAction = { index,title in
            if title != self.viewModel.sortOption.rawValue {
                self.viewModel.sortOption = title == UrlEndPoints.TopRated.rawValue  ? UrlEndPoints.TopRated:UrlEndPoints.MostPopular
                self.viewModel.MoviesData.accept([])
                self.title = self.viewModel.sortOption.rawValue
                self.viewModel.currantPage = 1
                self.viewModel.fetchMovies()
                
            }}
    }
    
    //dropdown button setup
    func setupDropDownMenu()->DropDown{
        let menue:DropDown = {
            let menue = DropDown()
            menue.dataSource = [UrlEndPoints.TopRated.rawValue,UrlEndPoints.MostPopular.rawValue]
            return menue
        }()
        
        guard let rightButtonView = navigationItem.rightBarButtonItem else { return menue }
        menue.anchorView = rightButtonView
        menue.direction = .bottom
        menue.bottomOffset = CGPoint(x: 0, y: 30)
        menue.cellHeight = 40
        menue.selectRow(at: 0)
        menue.selectionBackgroundColor = .red
        return menue
    }
    
    //Error alert present
    
    func showAlert(error:ApiError) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
}





