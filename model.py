import numpy as np
import PIL.Image
import matplotlib.pyplot as plt

from configuration import configuration

class Image(object):

    VALID_EXTENSIONS = '.png', '.jpg', '.jpeg'

    def __init__(self, filename, config=configuration):
        self.config = config
        self.filename = filename
        self.image = PIL.Image.open(filename, mode="r").convert("L")

        self._vector = self._calculate_vector()
        self._weights = self._calculate_weights()


    def _calculate_vector(self):
        resized_image = self.image.resize(self.config.size[::-1])
        matrix = np.asarray(resized_image)

        print matrix.shape

        vector = np.reshape(matrix, self.config.size[0] * self.config.size[1])

        vector = (vector > np.mean(vector)).astype(int)

        return vector

    def _calculate_weights(self):
        return np.dot(self._vector, self._vector.T)

    @property
    def vector(self):
        return self._vector

    @property
    def matrix(self):
        return self._vector.reshape(self.config.size)

    @property
    def weights(self):
        return self._weights


class HopfieldNetwork(object):

    pass

if __name__ == "__main__":
    image = Image('brain.jpg')

    plt.imshow(image.matrix)
    plt.show()