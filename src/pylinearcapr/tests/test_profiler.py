import unittest

from .. import StructuralProfiler, Context

SEQ = "ACGCUGUCUGUACUUGUAUCAGUACACUGACGAGUCCCUAAAGGACGAAACAGCGC"

class TestProfiler(unittest.TestCase):

    DELTA = 1e-5

    def test_example_turner1999(self):
        profiler = StructuralProfiler(energy_model="turner1999")
        profile = profiler.profile(SEQ)
      
        self.assertEqual(profile.matrix.shape[0], 6)
        self.assertEqual(profile.matrix.shape[1], len(SEQ))

        self.assertAlmostEqual(profile.matrix[Context.B, 1], 3.6242e-10, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.S, 1], 0.891229, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.S, 2], 0.999688, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.B, 2], 2.92873e-07, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.E, 2], 0.000237711, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.H, 2], 8.20875e-08, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.I, 3], 2.52053e-05, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.M, 4], 0.0165036, delta=self.DELTA)

    def test_example_turner2004(self):
        profiler = StructuralProfiler(energy_model="turner2004")
        profile = profiler.profile(SEQ)

        self.assertEqual(profile.matrix.shape[0], 6)
        self.assertEqual(profile.matrix.shape[1], len(SEQ))

        self.assertAlmostEqual(profile.matrix[Context.B, 1], 6.35298e-09, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.S, 1], 0.960011, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.S, 2], 0.997636, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.B, 2], 1.63607e-06, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.E, 2], 0.00231375, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.H, 2], 2.48346e-069, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.I, 3], 2.86463e-05, delta=self.DELTA)
        self.assertAlmostEqual(profile.matrix[Context.M, 4], 0.00480314, delta=self.DELTA)

    def test_empty_sequence(self):
        profiler = StructuralProfiler(energy_model="turner2004")
        profile = profiler.profile("")

    def test_invalid_energy_model(self):
        with self.assertRaises(ValueError):
            profiler = StructuralProfiler(energy_model="abcdef")

    