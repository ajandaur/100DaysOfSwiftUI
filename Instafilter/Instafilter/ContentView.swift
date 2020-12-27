//
//  ContentView.swift
//  Instafilter
//
//  Created by Anmol  Jandaur on 12/23/20.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    // MARK: Challenge 3 - Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.
    @State private var filterRadius = 0.5

    @State private var showingFilterSheet = false
    @State private var showingImagePicker = false
    @State private var processedImage: UIImage?
    @State private var inputImage: UIImage?
    
 
    
    // MARK: Challenge 2 - Make the Change Filter button change its title to show the name of the currently selected filter. Use a compute property for the current filter name.
    private var currentFilterName: String {
        let filterName = String(currentFilter.name)
        if filterName.hasPrefix("CI") && image != nil {
            return String(filterName.dropFirst(2))
        }
        return "Change Filter"
    }

    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    // MARK: Challenge 1 - state property to check whether an image is present
    @State private var noImagePresent = false

    var body: some View {
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        
        // Challenge 3: make another Binding for radius
        let radius = Binding<Double>(
            get: {
                self.filterRadius
            },
            set: {
                self.filterRadius = $0
                self.applyProcessing()
            }
        )

        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)

                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }

                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }.padding(.vertical)
                
                HStack {
                    Text("Radius")
                    Slider(value: radius)
                }.padding(.vertical)

                HStack {
                    // Challenge 2: Insert currentFilterName
                    Button(currentFilterName) {
                        self.showingFilterSheet = true
                    }

                    Spacer()

                    Button("Save") {
                        // save the image
                        
                        // Challenge 1: Check image to see if its not nil
                        guard self.image != nil else {
                            self.noImagePresent = true
                            return
                        }
                        
                        guard let processedImage = self.processedImage else { return }
                        let imageSaver = ImageSaver()
                        
                        imageSaver.successHandler = {
                            print("Success")
                        }
                        
                        imageSaver.errorHandler = {
                            print("Opps: \($0.localizedDescription)")
                        }
                        
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                        
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            
            // Challenge 1: alert for when there is no image present
            .alert(isPresented: $noImagePresent) {
                Alert(title: Text("Error"), message: Text("Could not save - no image selected"), dismissButton: .default(Text("Continue")))
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter:"), buttons: [
                    .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize()) },
                    .default(Text("Edges")) { self.setFilter(CIFilter.edges()) },
                    .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur()) },
                    .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate()) },
                    .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone()) },
                    .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask()) },
                    .default(Text("Vignette")) { self.setFilter(CIFilter.vignette()) },
                    .cancel()
                ])
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }

        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }

    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
